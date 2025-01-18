import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/menu_button.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/extensions/build_context_extensions.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/widgets/menu_button_widget.dart';
import 'package:gift_grab/presentation/widgets/smart_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends SmartBloc<AccountBloc, AccountState> {
  const SettingsScreen({super.key});

  @override
  Widget buildLoadedContent(BuildContext context, state) => Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: FlexGridviewWidget(
            children: [
              MenuButtonWidget(
                menuButton: MenuButton.editProfile,
                onTap: () => context.goNamed(
                  Globals.routes.editProfile,
                ),
              ),
              MenuButtonWidget(
                menuButton: MenuButton.linkedAccounts,
                onTap: () => context.goNamed(
                  Globals.routes.linkedAccounts,
                ),
              ),
              MenuButtonWidget(
                menuButton: MenuButton.signOut,
                onTap: () async {
                  final confirm = await ModalService.showConfirmation(
                    context: context,
                    title: 'Sign Out?',
                    message: 'Are you sure?',
                  );

                  if (confirm == null || confirm == false) {
                    return;
                  }

                  if (!context.mounted) return;

                  context.read<AuthBloc>().add(Logout());
                },
              ),
              MenuButtonWidget(
                menuButton: MenuButton.deleteAccount,
                onTap: () async {
                  final confirm = await ModalService.showInputMatchConfirmation(
                    context: context,
                    title: 'Delete Account?',
                    hintText: 'Enter your email to confirm.',
                    match: state.account.email!,
                  );

                  if (confirm == null || confirm == false) {
                    return;
                  }

                  if (!context.mounted) return;

                  context.read<AccountBloc>().add(DeleteAccount());
                },
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Settings',
      child: BlocConsumer<AccountBloc, AccountState>(
        listenWhen: (previous, current) => context.listenWhen(
          'settings',
        ),
        listener: listener,
        builder: builder,
      ),
    );
  }
}
