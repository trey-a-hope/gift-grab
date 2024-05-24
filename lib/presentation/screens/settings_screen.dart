import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ScreenBackgroundWidget(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Settings',
            style: theme.textTheme.displayLarge!.copyWith(
              fontSize: Globals.isTablet
                  ? theme.textTheme.displayLarge!.fontSize! * 2
                  : theme.textTheme.displayLarge!.fontSize,
            ),
          ),
          const Gap(50),
          GGButtonWidget(
            title: 'Edit Profile',
            onPressed: () => context.goNamed(Globals.routes.editProfile),
          ),
          const Gap(20),
          GGButtonWidget(
            title: 'Pick Avatar',
            onPressed: () => context.goNamed(Globals.routes.pickAvatar),
          ),
          const Gap(20),
          GGButtonWidget(
            title: 'Back',
            onPressed: () => context.pop(),
          ),
        ],
      ),
    ));
  }
}
