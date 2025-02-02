import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';

class ChannelMessageListTile extends StatelessWidget {
  final ChannelMessage message;

  const ChannelMessageListTile({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        _getMessageContent(message.content),
        style: theme.textTheme.headlineLarge,
      ),
      subtitle: Text(
        message.username,
        style: theme.textTheme.headlineSmall,
      ),
    );
  }

  String _getMessageContent(val) => jsonDecode(val)['name'];
}
