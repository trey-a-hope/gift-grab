import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/chat_room/chat_room_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRoomScreen extends SmartBloc<ChatRoomBloc, ChatRoomState> {
  final String room;

  const ChatRoomScreen({
    required this.room,
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    final theme = Theme.of(context);

    state = state as ChatRoomLoaded;

    final channel = state.channel;
    final user = state.user;

    if (channel == null || user == null) {
      throw Exception('Channel or user is null');
    }

    // TODO: Display presences as simple card widgets with users that uses a future listener.
    // final presences = channel.presences;

    final messages = state.messages;

    final convertedMessages = messages
        .map(
          (m) => types.TextMessage(
            author: types.User(id: m.senderId),
            id: m.messageId,
            text: _getMessageContent(m.content),
          ),
        )
        .toList();

    return Column(
      children: [
        Text(
          channel.roomName,
          style: theme.textTheme.headlineLarge,
        ),
        Expanded(
          child: Chat(
            messages: convertedMessages,
            onAttachmentPressed: null,
            onMessageTap: null,
            onPreviewDataFetched: null,
            onSendPressed: (val) {
              debugPrint('uid: ${user.id}');
              context.read<ChatRoomBloc>().add(
                    SendMessage(val.text),
                  );
            },
            showUserAvatars: true,
            showUserNames: true,
            user: user,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: room,
      child: SafeArea(
        child: Center(
          child: BlocProvider(
            create: (context) => ChatRoomBloc(
              authBloc: context.read<AuthBloc>(),
            )..add(ConnectToSocket(room)),
            child: BlocConsumer<ChatRoomBloc, ChatRoomState>(
              listenWhen: (previous, current) => context.listenWhen(
                Globals.routes.chatRoom,
              ),
              listener: listener,
              builder: builder,
            ),
          ),
        ),
      ),
    );
  }

  String _getMessageContent(val) => jsonDecode(val)['name'];
}
