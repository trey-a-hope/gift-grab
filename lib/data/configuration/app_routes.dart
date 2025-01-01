import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

GoRouter appRoutes({required bool isAuthenticated}) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/${Globals.routes.main}',
    routes: [
      GoRoute(
        path: '/${Globals.routes.main}',
        name: Globals.routes.main,
        builder: (context, state) => const MainMenuScreen(),
        routes: [
          GoRoute(
            path: Globals.routes.game,
            name: Globals.routes.game,
            builder: (context, state) => const GameScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) => isAuthenticated ? null : '',
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            'Page not found',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
    ),
  );
}
