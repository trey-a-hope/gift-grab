import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/domain/models/session_data_model.dart';
import 'package:gift_grab/domain/notifiers/nakama_auth_leaderboard_notifier.dart';
import 'package:gift_grab/domain/notifiers/nakama_auth_notifier.dart';
import 'package:gift_grab/domain/notifiers/nakama_session_data_notifier.dart';
import 'package:gift_grab/presentation/games/gift_grab_flame_game.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class Providers {
  static final ref = ProviderContainer();

  static final nakamaAuthProvider =
      AsyncNotifierProvider<NakamaAuthNotifier, bool>(NakamaAuthNotifier.new);

  static final nakamaLeaderboardProvider =
      AsyncNotifierProvider<NakamaLeaderboardNotifier, List<LeaderboardRecord>>(
          NakamaLeaderboardNotifier.new);

  static final nakamaSessionDataProvider =
      AsyncNotifierProvider<NakamaSessionDataNotifier, SessionData?>(
          NakamaSessionDataNotifier.new);

  static final routerProvider = Provider<GoRouter>(
    (ref) {
      final nakamaAuthProvider = ref.watch(Providers.nakamaAuthProvider);
      final isAuthenticated = nakamaAuthProvider.value != null;
      return appRoutes(isAuthenticated);
    },
  );

  static final giftGrabFlameGameProvider = Provider<GiftGrabFlameGame>(
    (ref) => GiftGrabFlameGame(),
  );
}
