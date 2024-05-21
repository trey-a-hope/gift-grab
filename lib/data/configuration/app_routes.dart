import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/screens/edit_profile_screen.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:gift_grab/presentation/screens/leaderboard_screen.dart';
import 'package:gift_grab/presentation/screens/login_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter appRoutes(bool isAuthenticated) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/${Globals.routes.main}',
    routes: [
      GoRoute(
        path: '/${Globals.routes.login}',
        name: Globals.routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
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
          GoRoute(
            path: Globals.routes.leaderboard,
            name: Globals.routes.leaderboard,
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
              path: Globals.routes.settings,
              name: Globals.routes.settings,
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: Globals.routes.editProfile,
                  name: Globals.routes.editProfile,
                  builder: (context, state) => EditProfileScreen(),
                ),
              ]),
        ],
      ),
    ],
    redirect: (context, state) =>
        isAuthenticated ? null : '/${Globals.routes.login}',
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
