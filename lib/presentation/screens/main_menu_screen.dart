import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(FetchAccountEvent());
  }

  @override
  Widget build(BuildContext context) {
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
            BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                return switch (state) {
                  AccountLoading() => const CircularProgressIndicator(),
                  AccountLoaded() => Text(
                      'Welcome Back, ${state.account.user.username ?? 'UNKNOWN'}',
                      style: theme.textTheme.displayLarge!.copyWith(
                          fontSize: theme.textTheme.bodyLarge!.fontSize! * 2),
                    ),
                  AccountError() => Text(
                      'Error: ${state.message}',
                      style: theme.textTheme.displayLarge!.copyWith(
                          fontSize: theme.textTheme.bodyLarge!.fontSize! * 2,
                          color: Colors.red),
                    ),
                  _ => Text(
                      'Error: Should not see this...',
                      style: theme.textTheme.displayLarge!.copyWith(
                          fontSize: theme.textTheme.bodyLarge!.fontSize! * 2,
                          color: Colors.red),
                    ),
                };
              },
            ),
            const Gap(64),
            GGButtonWidget(
              title: 'Play',
              onPressed: () => context.goNamed(Globals.routes.game),
            ),
            const Gap(16),
            GGButtonWidget(
              title: 'Leaderboard',
              onPressed: () => context.goNamed(Globals.routes.leaderboard),
            ),
            const Gap(16),
            GGButtonWidget(
              title: 'Groups',
              onPressed: () => context.goNamed(Globals.routes.groups),
            ),
            const Gap(16),
            GGButtonWidget(
              title: 'Settings',
              onPressed: () => context.goNamed(Globals.routes.settings),
            ),
            const Gap(50),
          ],
        ),
      ),
    );
  }
}
