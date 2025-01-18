import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class GGScaffoldWidget extends StatelessWidget {
  const GGScaffoldWidget({
    super.key,
    required this.child,
    required this.title,
    this.canPop = true,
  });

  final Widget child;
  final String title;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: canPop
            ? IconButton.filledTonal(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back),
              )
            : SizedBox(),
        title: Text(
          title,
          style: theme.textTheme.displayLarge,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.70,
            image: AssetImage("assets/images/${Globals.backgroundSprite}"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
