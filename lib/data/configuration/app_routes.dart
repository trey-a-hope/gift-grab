import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:gift_grab/presentation/screens/leaderboard_screen.dart';
import 'package:gift_grab/presentation/screens/login_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

GoRouter appRoutes(bool isAuthenticated) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/${Globals.routeMain}',
    routes: [
      GoRoute(
        path: '/${Globals.routeLogin}',
        name: Globals.routeLogin,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/${Globals.routeMain}',
        name: Globals.routeMain,
        builder: (context, state) => const MainMenuScreen(),
        routes: [
          GoRoute(
            path: Globals.routeLeaderboard,
            name: Globals.routeLeaderboard,
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: Globals.routeGame,
            name: Globals.routeGame,
            builder: (context, state) => const GameScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) =>
        isAuthenticated ? null : '/${Globals.routeLogin}',
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
