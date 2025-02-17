import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/profanity_service.dart';
import 'package:gift_grab/data/services/storage/base_storage_service.dart';
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

  late DirectChatStorage _senderDirectChatStorage;
  late DirectChatStorage _sendeeDirectChatStorage;

  ChatRoomBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        _webSocketService = WebSocketService(),
        _profanityService = ProfanityService(),
        super(
          ChatRoomState(
            null,
            null,
            null,
            [],
          ),
        ) {
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
        state.type,
        state.channel,
        state.messages,
      ));

  Future<void> _onConnectToSocket(
    ConnectToSocket event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatRoomLoading(
      null,
      event.channelType,
      state.channel,
      state.messages,
    ));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      late Channel channel;
      switch (event.channelType) {
        case ChannelType.directMessage:
          channel = await _joinChannelDirectMessage(userId: event.target);

          _sendeeDirectChatStorage = DirectChatStorage(uid: channel.userIdOne);
          _senderDirectChatStorage = DirectChatStorage(uid: channel.userIdTwo);

        case ChannelType.group:
          channel = await _joinChannelGroup(groupId: event.target);
        case ChannelType.room:
          channel = await _joinChannelRoom(roomName: event.target);
      }

      // Note: Instead of fetching all messages again, just insert the new one.
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
          state.type,
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
          type: state.type,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          user: state.user!,
          message: 'Unexpected error: ${e.toString()}',
          channel: state.channel,
          messages: state.messages,
          type: state.type,
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
          state.type,
          state.channel,
          messages ?? [],
        ),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomError(
          user: state.user,
          type: state.type,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          channel: state.channel,
          messages: state.messages,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          user: state.user,
          type: state.type,
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
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);

      final channelId = state.channel!.id;

      // Check for profanity.
      await _profanityService.check(event.text);

      if (state.type == ChannelType.directMessage) {
        final sendeeUid = state.channel!.userIdOne;
        final senderUid = state.channel!.userIdTwo;

        debugPrint('Sendee: $sendeeUid');
        debugPrint('Sender: $senderUid');

        // Add other uid to list of directs for this user.
        final senderDirects =
            await _senderDirectChatStorage.getValue(session, null);
        if (!senderDirects.contains(sendeeUid)) {
          await _senderDirectChatStorage.updateValue(
            session,
            [sendeeUid],
          );
        }

        final sendeeDirects =
            await _sendeeDirectChatStorage.getValue(session, null);
        if (!sendeeDirects.contains(senderUid)) {
          await _sendeeDirectChatStorage.updateValue(
            session,
            [senderUid],
          );
        }
      }

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
          type: state.type,
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          channel: state.channel,
          messages: state.messages,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          user: state.user,
          type: state.type,
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
