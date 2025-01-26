import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:gift_grab/data/configuration/nakama_properties.dart';
import 'package:gift_grab/data/services/web_socket_service.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:gift_grab/domain/blocs/notifications/notifications_bloc.dart';
import 'package:nakama/nakama.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gift_grab/domain/blocs/group/group_users/group_users_bloc.dart';

// mason make bloc --name [BLOC NAME] --style basic
// https://pub.dev/packages/cloudinary_public for image storage
// TODO: Replace all context.goNamed -> context.pushNamed.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  NakamaProperties.initialize(
    isDev: false,
    key: dotenv.env['NAKAMA_SERVER_KEY']!,
  );

  getNakamaClient(
    host: NakamaProperties.host,
    ssl: NakamaProperties.ssl,
    serverKey: NakamaProperties.serverKey,
    httpPort: NakamaProperties.httpPort,
  );

  runApp(
    AppInfo(
      // Retrieve an AppInfoData instance pre-populated with package, platform, and target data
      data: await AppInfoData.get(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authBloc = AuthBloc();

  @override
  void dispose() {
    WebSocketService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = appRouter(
      _authBloc..add(CheckAuthStatus()),
    );

    return MultiBlocProvider(
      providers: [
        // Auth
        BlocProvider<AuthBloc>(
          create: (context) => _authBloc,
        ),
        // Account
        BlocProvider<AccountBloc>(
          create: (context) => AccountBloc(
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        // Note: These are needed in multiple different screens.
        BlocProvider<AllGroupsBloc>(
          create: (context) => AllGroupsBloc(
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        BlocProvider<MyGroupsBloc>(
          create: (context) => MyGroupsBloc(
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        BlocProvider<GroupUsersBloc>(
          create: (context) => GroupUsersBloc(
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        BlocProvider<LeaderboardBloc>(
          create: (context) => LeaderboardBloc(
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        // Note: Needed to start listening for incoming notifications.
        BlocProvider<NotificationsBloc>(
          create: (context) => NotificationsBloc(
            authBloc: context.read<AuthBloc>(),
          ),
        ),
      ],
      child: ToastificationWrapper(
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
      ),
    );
  }
}
