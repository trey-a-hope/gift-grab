import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nakama/nakama.dart';
// ignore: implementation_imports
import 'package:nakama/src/models/notification.dart' as n;
import 'package:timeago/timeago.dart' as timeago;

// Code	Purpose
// 0	Reserved
// -1	Message received from user X while offline or not in channel.
// -2	User X wants to add you as a friend.
// -3	User X accepted your friend invite.
// -4	You’ve been accepted to X group.
// -5	User X wants to join your group.
// -6	Your friend X has just joined the game.
// -7	Final notifications to sockets closed via the single_socket configuration.
// -8	You’ve been banned.

class NotificationListTile extends StatelessWidget {
  final n.Notification notification;
  final void Function() delete;

  const NotificationListTile(
    this.notification, {
    required this.delete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              tileColor: theme.colorScheme.onInverseSurface,
              leading: _getIconFromCode(notification.code),
              title: Text(notification.subject ?? 'No Subjet'),
              subtitle: Text(timeago.format(notification.createTime)),
            ),
          ),
          Row(
            children: [
              if (notification.code == -1) ...[
                ElevatedButton(
                  onPressed: () {
                    final map = json.decode(notification.content!);
                    context.pushNamed(
                      Globals.routes.chatRoom,
                      pathParameters: {
                        'target': notification.senderId,
                        'title': map['username'],
                      },
                      extra: ChannelType.directMessage,
                    );
                  },
                  child: Text('Join Chat'),
                ),
              ],
              ElevatedButton(
                onPressed: delete,
                child: Text('Delete'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Icon _getIconFromCode(int code) {
    switch (code) {
      case 0:
      case -1:
        return Icon(Icons.mail);
      case -2:
      case -3:
      case -4:
      case -5:
      case -6:
        return Icon(MdiIcons.robotHappy);
      case -7:
      case -8:
        return Icon(Icons.cancel);
      default:
        return Icon(Icons.mail);
    }
  }
}
