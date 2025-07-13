import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/repositories/auth_stream_repository.dart';
import 'package:gift_grab/presentation/pages/game_page.dart';
import 'package:gift_grab/presentation/pages/login_page.dart';
import 'package:gift_grab/presentation/pages/main_menu_page.dart';
import 'package:gift_grab/presentation/pages/settings_page.dart';
import 'package:gift_grab_ui/util/stream_to_listenable_util.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter(AuthStreamRepository authRepository) => GoRouter(
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
          path: '/${Globals.routes.main}',
          name: Globals.routes.main,
          builder: (context, state) => const MainMenuPage(),
        ),
        GoRoute(
          path: '/${Globals.routes.game}',
          name: Globals.routes.game,
          builder: (context, state) => const GamePage(),
        ),
        GoRoute(
          path: '/${Globals.routes.login}',
          name: Globals.routes.login,
          builder: (context, __) => LoginPage(
            context.read<AuthStreamRepository>(),
          ),
        ),
        GoRoute(
          path: '/${Globals.routes.settings}',
          name: Globals.routes.settings,
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    );
