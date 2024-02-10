import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/domain/notifiers/nakama_leaderboard_async_notifier.dart';
import 'package:gift_grab/domain/notifiers/nakama_session_async_notifier.dart';
import 'package:gift_grab/presentation/games/gift_grab_flame_game.dart';
import 'package:gift_grab/util/config/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';

class Providers {
  static final ref = ProviderContainer();

  static final nakamaSessionAsyncNotifierProvider =
      AsyncNotifierProvider<NakamaSessionAsyncNotifier, Session?>(
    NakamaSessionAsyncNotifier.new,
  );

  static final nakamaLeaderboardAsyncNotifierProvider = AsyncNotifierProvider<
      NakamaLeaderboardAsyncNotifier, List<LeaderboardRecord>>(
    NakamaLeaderboardAsyncNotifier.new,
  );

  static final routerProvider = Provider<GoRouter>(
    (ref) {
      final nakamaSessionAsyncNotifierProvider =
          ref.watch(Providers.nakamaSessionAsyncNotifierProvider);
      final isAuthenticated = nakamaSessionAsyncNotifierProvider.value != null;
      return appRoutes(isAuthenticated);
    },
  );

  static final giftGrabFlameGameProvider = Provider<GiftGrabFlameGame>(
    (ref) => GiftGrabFlameGame(),
  );
}
