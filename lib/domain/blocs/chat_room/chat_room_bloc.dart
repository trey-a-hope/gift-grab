import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
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

  StreamSubscription? _channelMessageSubscription;

  ChatRoomBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        _webSocketService = WebSocketService(),
        super(ChatRoomState(
          null,
          null,
          [],
        )) {
    on<ConnectToSocket>(_onConnectToSocket);
    on<FetchMessages>(_onFetchMessages);
    on<SendMessage>(_onSendMessage);
  }

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
      if (session == null) return;

      final channel = await _webSocketService.socket?.joinChannel(
        target: event.room,
        type: ChannelType.room,
        persistence: true,
        hidden: false,
      );

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

      if (channel == null) {
        throw Exception('Channel is null.');
      }

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
      if (session == null) return;

      final channelId = state.channel!.id;

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
    final channelId = state.channel!.id;
    await _webSocketService.socket?.leaveChannel(channelId: channelId);
    _channelMessageSubscription?.cancel();
    debugPrint('leaveChannel: $channelId, success.');

    return super.close();
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      final channelId = state.channel!.id;

      final content = {
        'name': event.text,
      };

      final channelMessageAck = await _webSocketService.socket?.sendMessage(
        channelId: channelId,
        content: content,
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
          message: 'Unexpected error: ${e.toString()}',
          channel: state.channel,
          messages: state.messages,
        ),
      );
    }
  }
}
