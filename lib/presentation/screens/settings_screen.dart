import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
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
          SizedBox(
            width: Globals.isTablet ? 400 : 250,
            height: Globals.isTablet ? 100 : 50,
            child: ElevatedButton(
              onPressed: () => context.goNamed(Globals.routes.editProfile),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: Globals.isTablet ? 50 : 25,
                ),
              ),
            ),
          ),
          const Gap(20),
          SizedBox(
            width: Globals.isTablet ? 400 : 200,
            height: Globals.isTablet ? 100 : 50,
            child: ElevatedButton(
              onPressed: () => context.pop(),
              child: Text(
                'Back',
                style: TextStyle(
                  fontSize: Globals.isTablet ? 50 : 25,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
