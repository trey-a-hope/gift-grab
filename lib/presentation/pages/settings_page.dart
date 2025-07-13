import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/enums/menu_button.dart';
import 'package:gift_grab/data/repositories/auth_stream_repository.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview_widget.dart';
import 'package:gift_grab/presentation/widgets/menu_button_widget.dart';
import 'package:gift_grab_ui/util/modal_util.dart';
import 'package:gift_grab_ui/widgets/gg_scaffold_widget.dart';

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

    return GGScaffoldWidget(
      title: 'Settings',
      child: Padding(
        padding: EdgeInsetsGeometry.all(32),
        child: FlexGridviewWidget(
          children: [
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
          ],
        ),
      ),
    );
  }
}
