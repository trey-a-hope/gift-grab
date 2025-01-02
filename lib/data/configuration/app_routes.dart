import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:gift_grab/presentation/screens/login_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

GoRouter appRoutes() {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/${Globals.routes.main}',
    routes: [
      GoRoute(
        path: '/${Globals.routes.login}',
        name: Globals.routes.login,
        builder: (_, __) => LoginScreen(),
      ),
      GoRoute(
        path: '/${Globals.routes.main}',
        name: Globals.routes.main,
        builder: (context, state) => MainMenuScreen(),
        routes: [
          GoRoute(
            path: Globals.routes.game,
            name: Globals.routes.game,
            builder: (context, state) => const GameScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = context.watch<AuthBloc>().state;

      return authState.isAuthenticated ? '/main' : '/login';

      // // If not authenticated and not on login page, redirect to login
      // if (!authState.isAuthenticated &&
      //     !state.matchedLocation.startsWith('/login')) {
      //   return '/login';
      // }

      // // If authenticated and on login page, redirect to home
      // if (authState.isAuthenticated &&
      //     state.matchedLocation.startsWith('/login')) {
      //   return '/';
      // }

      // return null;
    },
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
