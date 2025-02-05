import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/profanity_service.dart';
import 'package:gift_grab/data/services/web_socket_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nakama/nakama.dart';
part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final AuthBloc authBloc;

  final NakamaService _nakamaService;
  final WebSocketService _webSocketService;
  final ProfanityService _profanityService;

  StreamSubscription? _channelMessageSubscription;

  ChatRoomBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        _webSocketService = WebSocketService(),
        _profanityService = ProfanityService(),
        super(ChatRoomState(
          null,
          null,
          [],
        )) {
    on<RebuildScreen>(_onRebuildScreen);
    on<ConnectToSocket>(_onConnectToSocket);
    on<FetchMessages>(_onFetchMessages);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onRebuildScreen(
    RebuildScreen event,
    Emitter<ChatRoomState> emit,
  ) async =>
      emit(ChatRoomLoaded(
        state.user,
        state.channel,
        state.messages,
      ));

  Future<void> _onConnectToSocket(
    ConnectToSocket event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatRoomLoading(
      null,
      state.channel,
      state.messages,
    ));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      late Channel channel;
      switch (event.channelType) {
        case ChannelType.directMessage:
          channel = await _joinChannelDirectMessage(userId: event.target);
        case ChannelType.group:
          channel = await _joinChannelGroup(groupId: event.target);
        case ChannelType.room:
          channel = await _joinChannelRoom(roomName: event.target);
      }

      // TODO: Instead of fetching all messages again, just insert the new one.
      // This requires a bug fix where the ChannelMessage is defined in both
      // package:nakama/src/models/channel_message.dart
      // and
      // package:nakama/src/api/proto/api/api.pb.dart';
      // Currently, I have to refetch all messages again...
      _channelMessageSubscription =
          _webSocketService.socket?.onChannelMessage.listen(
        (channelMessage) => add(FetchMessages()),
      );

      final account = await getNakamaClient().getAccount(session);

      emit(
        ChatRoomLoading(
          types.User(
            id: session.userId,
            firstName: account.user.username,
            lastName: 'Last Name',
          ),
          channel,
          [],
        ),
      );

      add(FetchMessages());
      debugPrint('_onConnectToSocket');
    } on GrpcError catch (e) {
      emit(
        ChatRoomError(
          user: state.user!,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          channel: state.channel,
          messages: state.messages,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          user: state.user!,
          message: 'Unexpected error: ${e.toString()}',
          channel: state.channel,
          messages: state.messages,
        ),
      );
    }
  }

  Future<void> _onFetchMessages(
    FetchMessages event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final channelId = state.channel!.id;

      if (channelId == '') return;

      final channelMessageList = await getNakamaClient().listChannelMessages(
        session: session,
        channelId: channelId,
      );

      final messages = channelMessageList.messages;

      emit(
        ChatRoomLoaded(
          state.user,
          state.channel,
          messages ?? [],
        ),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomError(
          user: state.user,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          channel: state.channel,
          messages: state.messages,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          user: state.user,
          message: 'Unexpected error: ${e.toString()}',
          channel: state.channel,
          messages: state.messages,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    final channelId = state.channel?.id;
    if (channelId != null) {
      await _webSocketService.socket?.leaveChannel(channelId: channelId);
    }
    _channelMessageSubscription?.cancel();
    return super.close();
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      await _nakamaService.getValidSessionOrLogout(authBloc);

      final channelId = state.channel!.id;

      await _profanityService.check(event.text);

      final channelMessageAck = await _webSocketService.socket?.sendMessage(
        channelId: channelId,
        content: {'name': event.text},
      );

      if (channelMessageAck == null) {
        throw Exception('channelMessageAck is null');
      }
    } on GrpcError catch (e) {
      emit(
        ChatRoomError(
          user: state.user,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          channel: state.channel,
          messages: state.messages,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          user: state.user,
          message: e.toString(),
          channel: state.channel,
          messages: state.messages,
        ),
      );
    }
  }

  Future<Channel> _joinChannelDirectMessage({
    required String userId,
  }) async {
    try {
      return _joinChannel(
        target: userId,
        type: ChannelType.directMessage,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Channel> _joinChannelGroup({
    required String groupId,
  }) async {
    try {
      return _joinChannel(
        target: groupId,
        type: ChannelType.group,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Channel> _joinChannelRoom({
    required String roomName,
  }) async {
    try {
      return _joinChannel(
        target: roomName,
        type: ChannelType.room,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Channel> _joinChannel({
    required String target,
    required ChannelType type,
  }) async {
    try {
      final channel = await _webSocketService.socket?.joinChannel(
        target: target,
        type: type,
        persistence: true,
        hidden: false,
      );

      return channel!;
    } catch (e) {
      throw Exception(e);
    }
  }
}
