import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/menu_button.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class MenuButtonWidget extends StatelessWidget {
  final MenuButton menuButton;
  final VoidCallback? action;

  const MenuButtonWidget({
    super.key,
    required this.menuButton,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => menuButton.route == null
          ? action!()
          : context.goNamed(menuButton.route!),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            32,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Expanded(
                child: Lottie.network(
                  menuButton.lottieUrl,
                  height: 100,
                ),
              ),
              Text(
                menuButton.name,
                style: theme.textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
