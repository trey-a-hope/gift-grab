import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class ChatRoomListTile extends StatelessWidget {
  final String room;

  const ChatRoomListTile({
    required this.room,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => context.pushNamed(
        Globals.routes.chatRoom,
        pathParameters: {'room': room},
      ),
      title: Text(
        room,
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
