import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/constants/menu_button.dart';
import 'package:gift_grab/data/services/modal_service.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/presentation/widgets/menu_button_widget.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Gift Grab',
      actions: [
        IconButton.filledTonal(
          onPressed: () async {
            final confirm = await ModalService.showConfirmation(
              context: context,
              title: 'Logout?',
              message: 'Are you sure?',
            );

            if (confirm != true) {
              return;
            }

            if (!context.mounted) return;

            context.read<AuthBloc>().add(Logout());
          },
          icon: Icon(Icons.logout),
        )
      ],
      canPop: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlexGridviewWidget(
                  children: [
                    MenuButtonWidget(
                      menuButton: MenuButton.play,
                      onTap: () => context.pushNamed(
                        Globals.routes.game,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
