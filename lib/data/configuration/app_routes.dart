import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/repositories/auth_stream_repository.dart';
import 'package:gift_grab/presentation/blocs/account/view/linked_accounts_page.dart';
import 'package:gift_grab/presentation/blocs/edit_profile/view/edit_profile_page.dart';
import 'package:gift_grab/presentation/blocs/friends/view/friends_page.dart';
import 'package:gift_grab/presentation/blocs/group_create/view/group_create_page.dart';
import 'package:gift_grab/presentation/blocs/groups_list/view/groups_page.dart';
import 'package:gift_grab/presentation/blocs/groups_list/widgets/group_details_page.dart';
import 'package:gift_grab/presentation/blocs/leaderboard/view/leaderboard_page.dart';
import 'package:gift_grab/presentation/blocs/profile/view/profile_page.dart';
import 'package:gift_grab/presentation/blocs/search_users/view/search_users_page.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:gift_grab/presentation/screens/login_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

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

GoRouter appRouter(AuthStreamRepository authRepository) => GoRouter(
      initialLocation: '/${Globals.routes.main}',
      refreshListenable: StreamToListenable([authRepository.authStateStream]),
      redirect: (context, state) {
        final isAuthenticated = authRepository.currentState.authenticated;

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
          builder: (context, __) => LoginScreen(
            context.read<AuthStreamRepository>(),
          ),
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
          path: '/${Globals.routes.friends}',
          name: Globals.routes.friends,
          builder: (context, state) => const FriendsPage(),
        ),
        GoRoute(
          path: '/${Globals.routes.groups}',
          name: Globals.routes.groups,
          builder: (context, state) => GroupsPage(),
          routes: [
            GoRoute(
              path: '${Globals.routes.createGroup}',
              name: Globals.routes.createGroup,
              builder: (context, state) => const GroupCreatePage(),
            ),
            GoRoute(
              path: '${Globals.routes.editGroup}/:groupId',
              name: Globals.routes.editGroup,
              builder: (context, state) {
                final groupId = state.pathParameters['groupId']!;
                final group = state.extra as Group;

                debugPrint('Group ID: $groupId');

                return GroupCreatePage(group: group);
              },
            ),
            GoRoute(
              path: '${Globals.routes.groupDetails}/:groupId',
              name: Globals.routes.groupDetails,
              builder: (context, state) {
                final groupId = state.pathParameters['groupId']!;
                final group = state.extra as Group;

                debugPrint('Group ID: $groupId');

                return GroupDetailsPage(group);
              },
            )
          ],
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
