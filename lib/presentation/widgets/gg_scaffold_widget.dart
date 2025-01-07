import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';

class GGScaffoldWidget extends StatelessWidget {
  const GGScaffoldWidget({
    super.key,
    required this.child,
    required this.title,
    this.goBack,
  });

  final Widget child;
  final String title;
  final void Function()? goBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: goBack == null
            ? SizedBox()
            : IconButton.filledTonal(
                onPressed: () => goBack!(),
                icon: Icon(Icons.arrow_back),
              ),
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
