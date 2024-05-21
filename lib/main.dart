import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/services/hive_session_service.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/providers.dart';
import 'package:nakama/nakama.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveSessionService.init();

  getNakamaClient(
    host: Globals.nakamaConfig.host,
    ssl: Globals.nakamaConfig.ssl,
    serverKey: Globals.nakamaConfig.serverKey,
    httpPort: Globals.nakamaConfig.httpPort,
  );

  runApp(
    ProviderScope(
      child: ToastificationWrapper(
        child: MaterialApp(
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const GiftGrabApp(),
        ),
      ),
    ),
  );
}

class GiftGrabApp extends ConsumerWidget {
  const GiftGrabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    checkDeviceType(context);

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

/// Sets the global isTablet variable based on the device type/dimensions.
Future<void> checkDeviceType(BuildContext context) async {
  // The equivalent of the "smallestWidth" qualifier on Android.
  final shortestSide = MediaQuery.of(context).size.shortestSide;

  // Determine if we should use mobile layout or not, 600 here is
  // a common breakpoint for a typical 7-inch tablet.
  Globals.isTablet = shortestSide >= 600;
}
