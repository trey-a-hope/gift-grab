import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:gift_grab/data/services/nakama_session_service.dart';
import 'package:gift_grab/data/services/social_auth_service.dart';
import 'package:gift_grab/domain/auth_stream_repository.dart';
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
        RepositoryProvider<NakamaSessionService>(
          create: (context) => NakamaSessionService(),
        ),
        RepositoryProvider<SocialAuthService>(
          create: (context) => SocialAuthService(),
        ),
        RepositoryProvider<AuthStreamRepository>(
          create: (context) => AuthStreamRepository(
            getNakamaClient(),
            context.read<NakamaSessionService>(),
            context.read<SocialAuthService>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AccountBloc>(
            create: (context) => AccountBloc(),
          ),
          BlocProvider<LeaderboardBloc>(
            create: (context) => LeaderboardBloc(),
          ),
          BlocProvider<FriendsBloc>(
            create: (context) => FriendsBloc(),
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

// TODO: Create interfaces for services into repos.
// TODO: event_handler_service and modal_service -> util or helper -> flutter package
