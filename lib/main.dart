import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:gift_grab/domain/blocs/account/account_bloc.dart';
import 'package:gift_grab/domain/blocs/auth/auth_bloc.dart';
import 'package:nakama/nakama.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  getNakamaClient(
    host: '127.0.0.1',
    ssl: false,
    serverKey: 'defaultkey',
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
          create: (context) =>
              AccountBloc(authBloc: authBloc)..add(FetchAccountEvent()),
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

    // return BlocProvider<AuthBloc>(
    //   create: (context) => authBloc,
    //   child: ToastificationWrapper(
    //     child: MaterialApp.router(
    //       debugShowCheckedModeBanner: false,
    //       theme: AppThemes.lightTheme,
    //       darkTheme: AppThemes.darkTheme,
    //       themeMode: ThemeMode.dark,
    //       title: 'Gift Grab',
    //       routeInformationProvider: router.routeInformationProvider,
    //       routerDelegate: router.routerDelegate,
    //       routeInformationParser: router.routeInformationParser,
    //     ),
    //   ),
    // );
  }
}
