import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/services/hive_service.dart';
import 'package:gift_grab/util/config/globals.dart';
import 'package:gift_grab/util/config/providers.dart';
import 'package:gift_grab/util/config/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.openHiveBox(boxName: 'settings');

  Globals.isTablet = true;

  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const GiftGrabApp(),
      ),
    ),
  );
}

class GiftGrabApp extends ConsumerWidget {
  const GiftGrabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(Providers.routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.dark,
      title: 'Gift Grab',
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
