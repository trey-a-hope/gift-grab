import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/services/hive_session_service.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:nakama/nakama.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:gift_grab/util/device_information.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveSessionService.init();
  Globals.isTablet = DeviceInformation.isTablet();

  getNakamaClient(
    host: Globals.nakamaHostIP,
    ssl: false,
    serverKey: 'defaultkey',
    httpPort: 7351,
  );

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
