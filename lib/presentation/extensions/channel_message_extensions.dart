import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nakama/nakama.dart';

extension ChannelMessageExtensions on ChannelMessage {
  types.TextMessage toTextMessage() => types.TextMessage(
        author: types.User(
          id: senderId,
          firstName: username,
        ),
        id: messageId,
        text: _getMessageContent(content),
      );

  String _getMessageContent(val) => jsonDecode(val)['name'];
}
