import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/presentation/screens/chat_room_screen.dart';
import 'package:gift_grab/presentation/screens/chat_rooms_screen.dart';
import 'package:gift_grab/presentation/screens/create_chat_room_screen.dart';
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

// Profile
final profileRoutes = [
  GoRoute(
    path: '/${Globals.routes.profile}/:uid',
    name: Globals.routes.profile,
    builder: (context, state) {
      final uid = state.pathParameters['uid'];
      if (uid == null) throw Exception();
      return ProfileScreen(uid: uid);
    },
  ),
  GoRoute(
    path: '/edit',
    name: Globals.routes.editProfile,
    builder: (context, state) => EditProfileScreen(),
  ),
];

// Groups
final groupRoutes = [
  GoRoute(
    path: '/${Globals.routes.groups}',
    name: Globals.routes.groups,
    builder: (context, state) => const GroupsScreen(),
  ),
  GoRoute(
    path: '/${Globals.routes.groupDetails}/:groupId',
    name: Globals.routes.groupDetails,
    builder: (context, state) {
      final group = state.extra as Group;
      return GroupDetailsScreen(
        group: group,
        initialContext: context,
      );
    },
  ),
  GoRoute(
    path: '/${Globals.routes.createGroup}',
    name: Globals.routes.createGroup,
    builder: (context, state) {
      return BlocListener<AllGroupsBloc, GroupsState>(
        listener: (context, state) {
          if (state is GroupsSuccess) {
            context.pop();

            context.read<AllGroupsBloc>().add(FetchGroups());
            context.read<MyGroupsBloc>().add(FetchGroups());
          }
        },
        child: CreateGroupScreen(),
      );
    },
  ),
  GoRoute(
    path: '/${Globals.routes.editGroup}/:groupId',
    name: Globals.routes.editGroup,
    builder: (context, state) {
      final group = state.extra as Group;
      return EditGroupScreen(group: group);
    },
  ),
];

GoRouter appRouter(AuthBloc authBloc) => GoRouter(
      debugLogDiagnostics: false,
      initialLocation: '/${Globals.routes.main}',
      routes: [
        ...profileRoutes,
        ...groupRoutes,
        GoRoute(
          path: '/${Globals.routes.login}',
          name: Globals.routes.login,
          builder: (_, __) => LoginScreen(),
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
              path: Globals.routes.chatRooms,
              name: Globals.routes.chatRooms,
              builder: (context, state) => const ChatRoomsScreen(),
            ),
            GoRoute(
              path: '${Globals.routes.chatRoom}/:room',
              name: Globals.routes.chatRoom,
              builder: (context, state) {
                final room = state.pathParameters['room'];
                if (room == null) throw Exception();
                return ChatRoomScreen(
                  room: room,
                );
              },
            ),
            GoRoute(
              path: Globals.routes.createChatRoom,
              name: Globals.routes.createChatRoom,
              builder: (context, state) => const CreateChatRoomScreen(),
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
              path: Globals.routes.notifications,
              name: Globals.routes.notifications,
              builder: (context, state) => const NotificationsScreen(),
            ),
            GoRoute(
              path: Globals.routes.settings,
              name: Globals.routes.settings,
              builder: (context, state) => const SettingsScreen(),
              routes: [
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
