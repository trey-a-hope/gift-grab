import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Gift Grab',
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: Globals.isTablet
                    ? theme.textTheme.displayLarge!.fontSize! * 2
                    : theme.textTheme.displayLarge!.fontSize,
              ),
            ),
            const Gap(16),
            Text(
              'Welcome Back, Trey',
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: Globals.isTablet
                    ? theme.textTheme.bodyLarge!.fontSize! * 2
                    : theme.textTheme.bodyLarge!.fontSize,
              ),
            ),
            const Gap(64),
            GGButtonWidget(
              title: 'Play',
              onPressed: () => context.goNamed(Globals.routes.game),
            ),
            const Gap(50),
          ],
        ),
      ),
    );
  }
}
