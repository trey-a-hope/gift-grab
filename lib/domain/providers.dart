import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/domain/models/account/account_model.dart';
import 'package:gift_grab/domain/notifiers/nakama_account_notifier.dart';
import 'package:gift_grab/domain/notifiers/nakama_auth_notifier.dart';
import 'package:gift_grab/presentation/games/gift_grab_flame_game.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:go_router/go_router.dart';

class Providers {
  static final ref = ProviderContainer();

  static final nakamaAccountProvider =
      AsyncNotifierProvider<NakamaAccountNotifier, AccountModel>(
          NakamaAccountNotifier.new);

  static final nakamaAuthProvider =
      AsyncNotifierProvider<NakamaAuthNotifier, bool>(NakamaAuthNotifier.new);
  static final routerProvider = Provider<GoRouter>(
    (ref) {
      final nakamaAuthProvider = ref.watch(Providers.nakamaAuthProvider);
      final isAuthenticated = nakamaAuthProvider.value == true;
      return appRoutes(isAuthenticated);
    },
  );

  static final giftGrabFlameGameProvider = Provider<GiftGrabFlameGame>(
    (ref) => GiftGrabFlameGame(),
  );
}
