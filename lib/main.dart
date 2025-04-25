import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
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
  Widget build(BuildContext context) {
    final router = appRouter(_authBloc..add(CheckAuthStatus()));

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => _authBloc,
        ),
        BlocProvider<AccountBloc>(
          create: (context) => AccountBloc(_authBloc),
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
