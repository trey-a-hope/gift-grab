import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/group/groups/groups_bloc.dart';
import 'package:gift_grab/domain/blocs/group/group_users/group_users_bloc.dart';
import 'package:gift_grab/domain/blocs/group/user_groups/user_groups_bloc.dart'
    as ugb;
import 'package:gift_grab/domain/blocs/group/all_groups/all_groups_bloc.dart'
    as agb;
import 'package:gift_grab/domain/blocs/leaderboard/leaderboard_bloc.dart';
import 'package:nakama/nakama.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _isDev = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  getNakamaClient(
    host: _isDev ? '127.0.0.1' : '24.144.85.68',
    ssl: false,
    serverKey: dotenv.env['NAKAMA_SERVER_KEY']!,
    httpPort: 7350,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc = AuthBloc()..add(CheckAuthStatusEvent());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = appRouter(authBloc);

    return MultiBlocProvider(
      providers: [
        // Auth
        BlocProvider<AuthBloc>(
          create: (context) => authBloc,
        ),
        // Account
        BlocProvider<AccountBloc>(
          create: (context) => AccountBloc(
            authBloc: authBloc,
          ),
        ),
        // Group
        BlocProvider<GroupsBloc>(
          create: (context) => GroupsBloc(
            accountBloc: context.read<AccountBloc>(),
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        // Group Users
        BlocProvider<GroupUsersBloc>(
          create: (context) => GroupUsersBloc(
            accountBloc: context.read<AccountBloc>(),
            authBloc: context.read<AuthBloc>(),
          ),
        ),
        // All Groups
        BlocProvider<agb.AllGroupsBloc>(
          create: (context) => agb.AllGroupsBloc(
            authBloc: context.read<AuthBloc>(),
          )..add(agb.FetchGroups()),
        ),
        // User Groups
        BlocProvider<ugb.UserGroupsBloc>(
            create: (context) => ugb.UserGroupsBloc(
                  accountBloc: context.read<AccountBloc>(),
                  authBloc: context.read<AuthBloc>(),
                )..add(ugb.FetchGroups())),
        // Leaderboard
        BlocProvider<LeaderboardBloc>(
          create: (context) => LeaderboardBloc(
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
