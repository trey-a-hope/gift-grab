import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class ClickableAvatar extends StatelessWidget {
  final User user;
  final VoidCallback? onProfileReturnCallback;

  const ClickableAvatar(
    this.user, {
    this.onProfileReturnCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await context.pushNamed(
          Globals.routes.profile,
          pathParameters: {'uid': user.id},
        );
        if (onProfileReturnCallback != null) {
          onProfileReturnCallback!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.green,
            width: user.online ? 3.0 : 0.0,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: Image.network(
            user.avatarUrl?.isEmpty ?? true
                ? Globals.emptyProfile
                : user.avatarUrl!,
          ).image,
        ),
      ),
    );
  }
}
