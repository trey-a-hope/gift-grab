import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/repositories/auth_stream_repository.dart';
import 'package:gift_grab/presentation/blocs/account/view/linked_accounts_page.dart';
import 'package:gift_grab/presentation/blocs/edit_profile/view/edit_profile_page.dart';
import 'package:gift_grab/presentation/blocs/profile/view/profile_page.dart';
import 'package:gift_grab/presentation/blocs/search_users/view/search_users_page.dart';
import 'package:gift_grab/presentation/pages/game_page.dart';
import 'package:gift_grab/presentation/pages/login_page.dart';
import 'package:gift_grab/presentation/pages/main_menu_page.dart';
import 'package:gift_grab/presentation/pages/settings_page.dart';
import 'package:gift_grab_ui/util/stream_to_listenable_util.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter(AuthStreamRepository authRepository) => GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/${Globals.routes.main}',
      refreshListenable:
          StreamToListenableUtil([authRepository.authStateStream]),
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
          path: '/${Globals.routes.login}',
          name: Globals.routes.login,
          builder: (context, __) => LoginPage(
            context.read<AuthStreamRepository>(),
          ),
        ),
        GoRoute(
          path: '/${Globals.routes.main}',
          name: Globals.routes.main,
          builder: (context, state) => const MainMenuPage(),
          routes: [
            GoRoute(
              path: Globals.routes.game,
              name: Globals.routes.game,
              builder: (context, state) => const GamePage(),
            ),
            GoRoute(
              path: Globals.routes.profile + '/:uid',
              name: Globals.routes.profile,
              builder: (context, state) {
                final uid = state.pathParameters['uid'];
                if (uid == null) throw Exception();
                return ProfilePage(uid);
              },
              routes: [
                GoRoute(
                  path: Globals.routes.editProfile, // Remove the leading '/'
                  name: Globals.routes.editProfile,
                  builder: (context, state) {
                    // You don't have to use the uid parameter if you don't need it
                    return const EditProfilePage();
                  },
                ),
              ],
            ),
            GoRoute(
              path: Globals.routes.searchUsers,
              name: Globals.routes.searchUsers,
              builder: (context, state) => const SearchUsersPage(),
            ),
            GoRoute(
              path: Globals.routes.settings,
              name: Globals.routes.settings,
              builder: (context, state) => const SettingsPage(),
              routes: [
                GoRoute(
                  path: Globals.routes.linkedAccounts,
                  name: Globals.routes.linkedAccounts,
                  builder: (context, state) => const LinkedAccountsPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
