import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:toastification/toastification.dart';

// mason make smart_bloc
// https://pub.dev/packages/cloudinary_public for image storage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  @override
  Widget build(BuildContext context) {
    final router = appRouter();

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
