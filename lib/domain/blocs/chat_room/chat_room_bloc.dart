import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/web_socket_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

// TODO: Impliment flutter_chat_ui: ^1.6.15
class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final AuthBloc authBloc;

  final NakamaService _nakamaService;
  final WebSocketService _webSocketService;
  ChatRoomBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        _webSocketService = WebSocketService(),
        super(ChatRoomState(null, [], '')) {
    on<ConnectToSocket>(_onConnectToSocket);
    on<FetchMessages>(_onFetchMessages);
    on<MessageUpdate>(_onMessageUpdate);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onConnectToSocket(
    ConnectToSocket event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatRoomLoading(
      state.channel,
      state.messages,
      state.text,
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

      if (channel == null) {
        throw Exception('Channel is null.');
      }

      add(
        FetchMessages(
          channel,
          false,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          channel: state.channel,
          messages: state.messages,
          text: state.text,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          message: 'Unexpected error: ${e.toString()}',
          channel: state.channel,
          messages: state.messages,
          text: state.text,
        ),
      );
    }
  }

  Future<void> _onFetchMessages(
    FetchMessages event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(
      ChatRoomLoading(
        event.channel,
        state.messages,
        event.clearInput ? '' : state.text,
      ),
    );

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
          state.channel,
          messages ?? [],
          state.text,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          channel: state.channel,
          messages: state.messages,
          text: state.text,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          message: 'Unexpected error: ${e.toString()}',
          channel: state.channel,
          messages: state.messages,
          text: state.text,
        ),
      );
    }
  }

  Future<void> _onMessageUpdate(
    MessageUpdate event,
    Emitter<ChatRoomState> emit,
  ) async =>
      emit(
        ChatRoomLoaded(
          state.channel,
          state.messages,
          event.text,
        ),
      );

  @override
  Future<void> close() async {
    final channelId = state.channel!.id;

    await _webSocketService.socket?.leaveChannel(channelId: channelId);
    debugPrint('leaveChannel: $channelId, success.');

    return super.close();
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatRoomLoading(
      state.channel,
      state.messages,
      state.text,
    ));

    try {
      final session = await _nakamaService.getValidSessionOrLogout(authBloc);
      if (session == null) return;

      final channelId = state.channel!.id;

      final channelMessageAck = await _webSocketService.socket
          ?.sendMessage(channelId: channelId, content: {
        'name': state.text,
      });
      debugPrint(channelMessageAck.toString());

      add(
        FetchMessages(
          state.channel!,
          true,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          channel: state.channel,
          messages: state.messages,
          text: state.text,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          message: 'Unexpected error: ${e.toString()}',
          channel: state.channel,
          messages: state.messages,
          text: state.text,
        ),
      );
    }
  }
}
