import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/chat_room/chat_room_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/extensions/channel_message_extensions.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class ChatRoomScreen extends SmartBloc<ChatRoomBloc, ChatRoomState> {
  final String title;
  final String target;
  final ChannelType channelType;

  const ChatRoomScreen({
    required this.title,
    required this.target,
    required this.channelType,
    super.key,
  });

  @override
  Widget buildLoadedContent(BuildContext context, dynamic state) {
    final theme = Theme.of(context);

    state = state as ChatRoomLoaded;

    final channel = state.channel;
    final user = state.user;
    final channelMessages = state.messages;

    if (channel == null || user == null) {
      throw Exception('Channel or user is null');
    }

    // TODO: Display presences as simple card widgets with users that uses a future listener.
    final presences = channel.presences;

    debugPrint(presences.toString());

    final textMessages = channelMessages
        .map((channelMessage) => channelMessage.toTextMessage())
        .toList();

    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < presences.length; i++) ...[
              Text(
                presences[i].username,
                style: theme.textTheme.headlineLarge,
              ),
            ]
          ],
        ),
        Expanded(
          child: Chat(
            customDateHeaderText: (date) => date.toIso8601String(),
            dateHeaderBuilder: (d) => Text(d.text),
            theme: DarkChatTheme(
              backgroundColor: Colors.transparent,
            ),
            avatarBuilder: (user) => CircleAvatar(
              backgroundImage: Image.network(
                user.imageUrl?.isEmpty ?? true
                    ? Globals.emptyProfile
                    : user.imageUrl!,
              ).image,
            ),
            onAvatarTap: (user) {
              context.pushNamed(
                Globals.routes.profile,
                pathParameters: {'uid': user.id},
              );
            },
            messages: textMessages,
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
  void listener(BuildContext context, ChatRoomState state) {
    super.listener(context, state);

    if (state is ChatRoomError) {
      context.read<ChatRoomBloc>().add(RebuildScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: title,
      child: Center(
        child: BlocProvider(
          create: (context) => ChatRoomBloc(
            authBloc: context.read<AuthBloc>(),
          )..add(ConnectToSocket(target, channelType)),
          child: BlocConsumer<ChatRoomBloc, ChatRoomState>(
            // listenWhen: (previous, current) => context.listenWhen(
            //   Globals.routes.chatRoom,
            // ),
            listener: listener,
            builder: builder,
          ),
        ),
      ),
    );
  }
}
