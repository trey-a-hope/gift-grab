import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/enums/menu_button.dart';
import 'package:gift_grab/presentation/widgets/flex_gridview_widget.dart';
import 'package:gift_grab/presentation/widgets/menu_button_widget.dart';
import 'package:gift_grab_ui/widgets/gg_scaffold_widget.dart';
import 'package:go_router/go_router.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainMenuView();
  }
}

class MainMenuView extends StatelessWidget {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Gift Grab',
      canPop: false,
      actions: [
        IconButton.filledTonal(
          onPressed: () => context.pushNamed(
            Globals.routes.settings,
          ),
          icon: Icon(Icons.settings),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(32),
        child: FlexGridviewWidget(
          children: [
            MenuButtonWidget(
              menuButton: MenuButton.play,
              onTap: () => context.pushNamed(Globals.routes.game),
            ),
          ],
        ),
      ),
    );
  }
}
