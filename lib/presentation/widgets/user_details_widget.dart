import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';

class UserDetailsWidget extends StatelessWidget {
  final User user;

  const UserDetailsWidget(
    this.user, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.username ?? 'No Name'),
    );
  }
}
