import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({
    super.key,
  });

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
            const Gap(16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return GGButtonWidget(
                  title: 'Sign Out',
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  },
                );
              },
            ),
            const Gap(50),
          ],
        ),
      ),
    );
  }
}
