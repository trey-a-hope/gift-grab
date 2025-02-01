import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/web_socket_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final AuthBloc authBloc;

  final NakamaService _nakamaService;
  final WebSocketService _webSocketService;
  ChatRoomBloc({
    required this.authBloc,
  })  : _nakamaService = NakamaService(),
        _webSocketService = WebSocketService(),
        super(ChatRoomState(null, '')) {
    on<ConnectToSocket>(_onConnectToSocket);
    on<MessageUpdate>(_onMessageUpdate);
  }

  Future<void> _onConnectToSocket(
    ConnectToSocket event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatRoomLoading(
      state.channel,
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

      emit(
        ChatRoomLoaded(
          channel,
          state.text,
        ),
      );
    } on GrpcError catch (e) {
      emit(
        ChatRoomError(
          message: e.message ?? 'Unknown GRPC Error: ${e.codeName}',
          channel: state.channel,
          text: state.text,
        ),
      );
    } catch (e) {
      emit(
        ChatRoomError(
          message: 'Unexpected error: ${e.toString()}',
          channel: state.channel,
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
        ChatRoomLoaded(state.channel, event.text),
      );

  @override
  Future<void> close() async {
    final channelId = state.channel?.id;
    if (channelId == null) {
      debugPrint('Could not leaveChannel; id was null.');
    } else {
      await _webSocketService.socket?.leaveChannel(channelId: channelId);
      debugPrint('leaveChannel: $channelId, success.');
    }

    return super.close();
  }
}
