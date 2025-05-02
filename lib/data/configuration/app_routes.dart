import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/blocs/account/view/linked_accounts_page.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
import 'package:gift_grab/presentation/blocs/leaderboard/view/leaderboard_page.dart';
import 'package:gift_grab/presentation/blocs/profile/view/edit_profile_page.dart';
import 'package:gift_grab/presentation/blocs/profile/view/profile_page.dart';
import 'package:gift_grab/presentation/blocs/search_users/view/search_users_page.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:gift_grab/presentation/screens/login_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';
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
      initialLocation: '/${Globals.routes.main}',
      refreshListenable: StreamToListenable([authBloc.stream]),
      redirect: (context, state) {
        final isAuthenticated = authBloc.state.authenticated;

        if (!isAuthenticated && !state.matchedLocation.contains('/login')) {
          return '/login';
        }

        if (isAuthenticated && state.matchedLocation == '/login') {
          return '/main';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/${Globals.routes.main}',
          name: Globals.routes.main,
          builder: (context, state) => const MainMenuPage(),
        ),
        GoRoute(
          path: '/${Globals.routes.game}',
          name: Globals.routes.game,
          builder: (context, state) => const GameScreen(),
        ),
        GoRoute(
          path: '/${Globals.routes.login}',
          name: Globals.routes.login,
          builder: (_, __) => LoginScreen(),
        ),
        GoRoute(
          path: '/${Globals.routes.profile}/:uid',
          name: Globals.routes.profile,
          builder: (context, state) {
            final uid = state.pathParameters['uid'];
            if (uid == null) throw Exception();
            return ProfilePage(uid);
          },
        ),
        GoRoute(
          path: '/${Globals.routes.editProfile}',
          name: Globals.routes.editProfile,
          builder: (context, state) => const EditProfilePage(),
        ),
        GoRoute(
          path: '/${Globals.routes.searchUsers}',
          name: Globals.routes.searchUsers,
          builder: (context, state) => const SearchUsersPage(),
        ),
        GoRoute(
          path: '/${Globals.routes.linkedAccounts}',
          name: Globals.routes.linkedAccounts,
          builder: (context, state) => LinkedAccountsPage(),
        ),
        GoRoute(
          path: '/${Globals.routes.leaderboard}/:uid',
          name: Globals.routes.leaderboard,
          builder: (context, state) {
            final uid = state.pathParameters['uid'];
            if (uid == null) throw Exception();
            return LeaderboardPage(uid);
          },
        ),
      ],
    );
