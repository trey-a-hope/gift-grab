import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

class NotificationWidget extends StatelessWidget {
  final n.Notification notification;
  final void Function() action;

  const NotificationWidget(
    this.notification, {
    required this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: action,
      leading: _getIconFromCode(notification.code),
      title: Text(notification.subject ?? 'No Subjet'),
      trailing: Text(timeago.format(notification.createTime)),
    );
  }

  Icon _getIconFromCode(int code) {
    switch (code) {
      case 0:
        return Icon(Icons.mail);
      case -1:
        return Icon(Icons.mail);
      case -2:
        return Icon(MdiIcons.robotHappy);
      case -3:
        return Icon(Icons.mail);
      case -4:
        return Icon(Icons.mail);
      case -5:
        return Icon(Icons.mail);
      case -6:
        return Icon(Icons.mail);
      case -7:
        return Icon(Icons.mail);
      case -8:
        return Icon(Icons.mail);
      default:
        return Icon(Icons.mail);
    }
  }
}
