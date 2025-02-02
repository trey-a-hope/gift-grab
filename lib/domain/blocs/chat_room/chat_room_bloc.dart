import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/data/services/nakama_service.dart';
import 'package:gift_grab/data/services/web_socket_service.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:nakama/nakama.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

part 'chat_room_event.dart';
part 'chat_room_state.dart';

//TODO: If send a message, then signout/sign with different account,
// then post message, it displays the correct bubble. However, if I
// leave the page and come back, the message I just posted is on the wrong side.
class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final AuthBloc authBloc;

  final NakamaService _nakamaService;
  final WebSocketService _webSocketService;
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

      debugPrint(channelMessageAck.toString());
      debugPrint('Message sent from uid: ${session.userId}');

      emit(
        ChatRoomLoaded(
          state.user,
          state.channel,
          [
            ChannelMessage(
              channelId: channelId,
              messageId: channelMessageAck.messageId,
              code: channelMessageAck.code,
              senderId: session.userId,
              username: channelMessageAck.username,
              content: jsonEncode(content),
              createTime: channelMessageAck.created,
              updateTime: channelMessageAck.updated,
              persistent: channelMessageAck.persistent,
              roomName: channelMessageAck.roomName,
              groupId: channelMessageAck.groupId,
              userIdOne: channelMessageAck.userIdOne,
              userIdTwo: channelMessageAck.userIdTwo,
            ),
            ...state.messages,
          ],
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
}
