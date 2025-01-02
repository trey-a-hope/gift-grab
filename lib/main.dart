import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/configuration/app_themes.dart';
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

  runApp(
    BlocProvider(
      create: (context) => AuthBloc()
        ..add(
          CheckAuthStatusEvent(),
        ),
      child: ToastificationWrapper(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.dark,
          title: 'Gift Grab',
          routerConfig: appRoutes(),
        ),
      ),
    ),

    // ToastificationWrapper(
    //   child: MaterialApp(
    //     theme: AppThemes.lightTheme,
    //     darkTheme: AppThemes.darkTheme,
    //     themeMode: ThemeMode.system,
    //     debugShowCheckedModeBanner: false,
    //     home: const GiftGrabApp(),
    //   ),
    // ),
  );
}

/// Sets the global isTablet variable based on the device type/dimensions.
Future<void> checkDeviceType(BuildContext context) async {
  // The equivalent of the "smallestWidth" qualifier on Android.
  final shortestSide = MediaQuery.of(context).size.shortestSide;

  // Determine if we should use mobile layout or not, 600 here is
  // a common breakpoint for a typical 7-inch tablet.
  Globals.isTablet = shortestSide >= 700;
}
