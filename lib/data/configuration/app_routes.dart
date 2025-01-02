import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:gift_grab/presentation/screens/leaderboard_screen.dart';
import 'package:gift_grab/presentation/screens/login_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:go_router/go_router.dart';

class StreamToListenable extends ChangeNotifier {
  late final List<StreamSubscription> subscriptions;

  StreamToListenable(List<Stream> streams) {
    subscriptions = [];
    for (var e in streams) {
      var s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (var e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}

GoRouter appRouter(AuthBloc authBloc) => GoRouter(
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
        ),
        GoRoute(
          path: '/${Globals.routes.main}/${Globals.routes.game}',
          name: Globals.routes.game,
          builder: (context, state) => const GameScreen(),
        ),
        GoRoute(
          path: '/${Globals.routes.main}/${Globals.routes.leaderboard}',
          name: Globals.routes.leaderboard,
          builder: (context, state) => const LeaderboardScreen(),
        ),
      ],
      refreshListenable: StreamToListenable([authBloc.stream]),
      redirect: (context, state) {
        final isAuthenticated = authBloc.state is Authenticated;

        if (!isAuthenticated && !state.matchedLocation.contains('/login')) {
          return '/login';
        }
        if (isAuthenticated && state.matchedLocation == '/login') {
          return '/main';
        }

        return null;
      },
    );
