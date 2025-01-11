import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Settings',
      goBack: () => context.goNamed(Globals.routes.main),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(32),
            ElevatedButton(
              child: Text('Edit Profile'),
              onPressed: () => context.goNamed(Globals.routes.editProfile),
            ),
            const Gap(16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) => ElevatedButton(
                child: Text('Sign Out'),
                onPressed: () async {
                  final confirm = await ModalService.showConfirmation(
                    context: context,
                    title: 'Sign Out?',
                    message: 'Are you sure?',
                  );

                  if (confirm == null || confirm == false) {
                    return;
                  }

                  if (!context.mounted) return;

                  context.read<AuthBloc>().add(LogoutEvent());
                },
              ),
            ),
            const Gap(16),
            BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) => switch (state) {
                AccountLoaded() => ElevatedButton(
                    child: Text('Delete Profile'),
                    onPressed: () async {
                      final confirm =
                          await ModalService.showInputMatchConfirmation(
                        context: context,
                        title: 'Delete Account?',
                        hintText: 'Enter your email to confirm.',
                        match: state.account.email!,
                      );

                      if (confirm == null || confirm == false) {
                        return;
                      }

                      if (!context.mounted) return;

                      context.read<AccountBloc>().add(DeleteAccountEvent());
                    },
                  ),
                _ => const SizedBox(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
