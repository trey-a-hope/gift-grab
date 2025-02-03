import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class ChatRoomListTile extends StatelessWidget {
  final String target;
  final ChannelType channelType;

  const ChatRoomListTile({
    required this.target,
    required this.channelType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => context.pushNamed(
        Globals.routes.chatRoom,
        pathParameters: {
          'target': target,
          'title': target,
        },
        extra: channelType,
      ),
      title: Text(
        target,
        style: theme.textTheme.displayLarge,
      ),
      trailing: IconButton.filledTonal(
        onPressed: null,
        icon: Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}
