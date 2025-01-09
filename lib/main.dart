import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:gift_grab/domain/blocs/group/group_bloc.dart';
import 'package:gift_grab/domain/blocs/group_my/group_my_bloc.dart' as m;
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
        BlocProvider<AuthBloc>(
          create: (context) => authBloc,
        ),
        BlocProvider<AccountBloc>(
          create: (context) => AccountBloc(
            authBloc: authBloc,
          ),
        ),
        BlocProvider<GroupBloc>(
          create: (context) => GroupBloc(
            accountBloc: context.read<AccountBloc>(),
          ),
        ),
        BlocProvider<m.GroupMyBloc>(
            create: (context) => m.GroupMyBloc(
                  accountBloc: context.read<AccountBloc>(),
                )..add(m.FetchGroups())),
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
