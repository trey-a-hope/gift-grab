import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:gift_grab/data/repositories/auth_stream_repository.dart';
import 'package:gift_grab/data/repositories/session_repository.dart';
import 'package:gift_grab/data/repositories/social_auth_repository.dart';
import 'package:gift_grab/data/repositories/storage_repository.dart';
import 'package:gift_grab/domain/services/games_played_storage_service.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/domain/services/social_auth_service.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/blocs/friends/bloc/friends_bloc.dart';
import 'package:gift_grab/presentation/blocs/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:nakama/nakama.dart';
import 'package:toastification/toastification.dart';

// mason make smart_bloc
// https://pub.dev/packages/cloudinary_public for image storage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  getNakamaClient(
    host: '24.144.85.68',
    ssl: false,
    serverKey: 'defaultkey',
  );

  runApp(
    AppInfo(
      data: await AppInfoData.get(),
      child: const MyAppPage(),
    ),
  );
}

class MyAppPage extends StatelessWidget {
  const MyAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SessionService>(
          create: (context) => SessionService(
            SessionRepository(
              const FlutterSecureStorage(),
              getNakamaClient(),
            ),
          ),
        ),
        RepositoryProvider<SocialAuthService>(
          create: (context) => SocialAuthService(
            SocialAuthRepository(),
          ),
        ),
        RepositoryProvider<AuthStreamRepository>(
          create: (context) => AuthStreamRepository(
            getNakamaClient(),
            context.read<SessionService>(),
            context.read<SocialAuthService>(),
          ),
        ),
        RepositoryProvider<GamesPlayedStorageService>(
          create: (context) => GamesPlayedStorageService(
            StorageRepository(
              getNakamaClient(),
            ),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AccountBloc>(
            create: (context) => AccountBloc(
              context.read<SessionService>(),
              context.read<SocialAuthService>(),
            ),
          ),
          BlocProvider<LeaderboardBloc>(
            create: (context) => LeaderboardBloc(
              context.read<SessionService>(),
              context.read<GamesPlayedStorageService>(),
            ),
          ),
          BlocProvider<FriendsBloc>(
            create: (context) => FriendsBloc(
              context.read<SessionService>(),
            ),
          ),
        ],
        child: MyAppView(),
      ),
    );
  }
}

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final authStreamRepo = context.read<AuthStreamRepository>();

    authStreamRepo.checkAuthStatus();

    final router = appRouter(authStreamRepo);

    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.dark,
        title: 'Gift Grab',
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
      ),
    );
  }
}

// TODO: Move components, inputs, overlays, spawners -> gift_grab_ui
