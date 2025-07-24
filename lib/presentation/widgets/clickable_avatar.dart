import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class ClickableAvatar extends StatelessWidget {
  final User user;
  const ClickableAvatar(this.user, {super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          await context.pushNamed(
            Globals.routes.profile,
            pathParameters: {'uid': user.id},
          );
        },
        child: CircleAvatar(
          backgroundImage: Image.network(
            user.avatarUrl?.isEmpty ?? true
                ? Globals.emptyProfile
                : user.avatarUrl!,
          ).image,
        ),
      );
}
