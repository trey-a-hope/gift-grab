import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:go_router/go_router.dart';

class Providers {
  static final ref = ProviderContainer();

  static final routerProvider = Provider<GoRouter>(
    (ref) {
      // final nakamaAuthProvider = ref.watch(Providers.nakamaAuthProvider);
      // final isAuthenticated = nakamaAuthProvider.value == true;
      return appRoutes(isAuthenticated: true);
    },
  );
}
