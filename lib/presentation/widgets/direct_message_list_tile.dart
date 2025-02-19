import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class DirectMessageListTile extends StatelessWidget {
  final String uid;

  const DirectMessageListTile({
    required this.uid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => context.pushNamed(
        Globals.routes.chatRoom,
        pathParameters: {
          'target': uid,
          'title': 'The other user...',
        },
        extra: ChannelType.directMessage,
      ),
      leading: CircleAvatar(
        child: Text(
          '1',
        ),
      ),
      title: Text(
        'My name is...',
        style: theme.textTheme.displayMedium,
      ),
      subtitle: Text(
        'What goes here?',
        style: theme.textTheme.bodyLarge!.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
