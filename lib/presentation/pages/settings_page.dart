import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/enums/menu_button.dart';
import 'package:gift_grab/data/repositories/auth_stream_repository.dart';
import 'package:gift_grab/presentation/blocs/account/account.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview_widget.dart';
import 'package:gift_grab/presentation/widgets/menu_button_widget.dart';
import 'package:gift_grab_ui/gift_grab_ui.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authStreamRepo = context.read<AuthStreamRepository>();
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return GGScaffoldWidget(
          title: 'Settings',
          child: Padding(
            padding: EdgeInsetsGeometry.all(32),
            child: FlexGridviewWidget(
              children: [
                MenuButtonWidget(
                  menuButton: MenuButton.licenses,
                  onTap: () => showLicensePage(context: context),
                ),
                MenuButtonWidget(
                  menuButton: MenuButton.linkedAccounts,
                  onTap: () => context.pushNamed(
                    Globals.routes.linkedAccounts,
                  ),
                ),
                MenuButtonWidget(
                  menuButton: MenuButton.logout,
                  onTap: () async {
                    final confirm = await ModalUtil.showConfirmation(
                      context,
                      title: 'Logout?',
                      message: 'Are you sure?',
                    );

                    if (confirm != true) {
                      return;
                    }

                    if (!context.mounted) return;

                    authStreamRepo.logout();
                  },
                ),
                if (state.account != null && state.account!.email != null) ...[
                  MenuButtonWidget(
                    menuButton: MenuButton.deleteAccount,
                    onTap: () async {
                      final confirm =
                          await ModalUtil.showInputMatchConfirmation(
                        context: context,
                        title: 'Delete Account?',
                        hintText: 'Enter your email to confirm.',
                        match: state.account!.email!,
                      );

                      if (confirm == null || confirm == false) {
                        return;
                      }

                      if (!context.mounted) return;

                      context.read<AccountBloc>().add(DeleteAccount());
                    },
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
