import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:nakama/nakama.dart';

// Code	Purpose	Source	Description
// 0	Chat Message	User	All messages sent by users.
// 1	Chat Update	User	A user updating a message they previously sent.
// 2	Chat Remove	User	A user removing a message they previously sent.
// 3	Joined Group	Server	An event message for when a user joined the group.
// 4	Added to Group	Server	An event message for when a user was added to the group.
// 5	Left Group	Server	An event message for when a user left a group.
// 6	Kicked from Group	Server	An event message for when an admin kicked a user from the group.
// 7	Promoted in Group	Server	An event message for when a user is promoted as a group admin.
// 8	Banned in Group	Server	An event message for when a user got banned from a group.
// 9	Demoted in Group	Server	An event message for when a user got demoted in a group.

extension ChannelMessageExtensions on ChannelMessage {
  types.TextMessage toTextMessage() => types.TextMessage(
        author: types.User(
          id: senderId,
          firstName: username,
        ),
        id: messageId,
        text: _getMessageContent(),
      );

  String _getMessageContent() {
    try {
      final Map<String, dynamic> map = jsonDecode(content);

      switch (code) {
        case 0:
          return map['name'];
        case 1:
          return '"$username updated a message"';
        case 2:
          return '"$username removed a message"';
        case 3:
          return '"$username has joined the group"';
        case 4:
          return '"$username was added to the group"';
        case 5:
          return '"$username has left the group"';
        case 6:
          return '"$username was kicked from the group"';
        case 7:
          return '"$username was promoted as group admin"';
        case 8:
          return '"$username was banned from the group"';
        case 9:
          return '"$username was demoted"';
        default:
          return '';
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
