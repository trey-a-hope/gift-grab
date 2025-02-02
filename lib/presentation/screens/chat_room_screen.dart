import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/chat_room/chat_room_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/widgets/channel_message_list_tile.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';

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

    if (channel == null) {
      throw Exception('Channel is null');
    }

    final presences = channel.presences;

    final text = state.text;

    final messages = state.messages;

    return Column(
      children: [
        Text(
          channel.roomName,
          style: theme.textTheme.headlineLarge,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (c, i) => ChannelMessageListTile(
              message: messages[i],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(32),
          child: GGInputFieldWidget(
            onChanged: (val) => context.read<ChatRoomBloc>().add(
                  MessageUpdate(val),
                ),
            onSend: () => context.read<ChatRoomBloc>().add(
                  SendMessage(),
                ),
            initialValue: state.text,
            hintText: 'Enter message',
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
}
