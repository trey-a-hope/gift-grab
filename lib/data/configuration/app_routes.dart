import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/presentation/screens/create_group_screen.dart';
import 'package:gift_grab/presentation/screens/edit_group_screen.dart';
import 'package:gift_grab/presentation/screens/edit_profile_screen.dart';
import 'package:gift_grab/presentation/screens/friends_screen.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:gift_grab/presentation/screens/group_details_screen.dart';
import 'package:gift_grab/presentation/screens/groups_screen.dart';
import 'package:gift_grab/presentation/screens/leaderboard_screen.dart';
import 'package:gift_grab/presentation/screens/linked_accounts_screen.dart';
import 'package:gift_grab/presentation/screens/login_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/screens/notifications_screen.dart';
import 'package:gift_grab/presentation/screens/profile_screen.dart';
import 'package:gift_grab/presentation/screens/search_users_screen.dart';
import 'package:gift_grab/presentation/screens/settings_screen.dart';
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
              path: Globals.routes.friends,
              name: Globals.routes.friends,
              builder: (context, state) => const FriendsScreen(),
            ),
            GoRoute(
              path: Globals.routes.searchUsers,
              name: Globals.routes.searchUsers,
              builder: (context, state) => const SearchUsersScreen(),
            ),
            GoRoute(
              path: 'profile/:uid/:prevRoute',
              name: Globals.routes.profile,
              builder: (context, state) {
                final uid = state.pathParameters['uid'];
                final prevRoute = state.pathParameters['prevRoute'];

                if (uid == null || prevRoute == null) throw Exception();

                return ProfileScreen(
                  uid: uid,
                  prevRoute: prevRoute,
                );
              },
            ),
            GoRoute(
              path: Globals.routes.notifications,
              name: Globals.routes.notifications,
              builder: (context, state) => NotificationsScreen(
                initialContext: context,
              ),
            ),
            GoRoute(
              path: Globals.routes.groups,
              name: Globals.routes.groups,
              builder: (context, state) => const GroupsScreen(),
              routes: [
                GoRoute(
                  path: Globals.routes.createGroup,
                  name: Globals.routes.createGroup,
                  builder: (context, state) => const CreateGroupScreen(),
                ),
                GoRoute(
                  path: ':groupId',
                  name: Globals.routes.groupDetails,
                  builder: (context, state) {
                    final group = state.extra as Group;
                    return GroupDetailsScreen(
                      group: group,
                      initialContext: context,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: Globals.routes.editGroup,
                      builder: (context, state) {
                        final group = state.extra as Group;
                        return EditGroupScreen(group: group);
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: Globals.routes.settings,
              name: Globals.routes.settings,
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: '/editProfile',
                  name: Globals.routes.editProfile,
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: '/linkedAccounts',
                  name: Globals.routes.linkedAccounts,
                  builder: (context, state) => const LinkedAccountsScreen(),
                ),
              ],
            ),
          ],
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
