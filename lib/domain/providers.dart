import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/domain/models/session_data_model.dart';
import 'package:gift_grab/domain/notifiers/nakama_leaderboard_notifier.dart';
import 'package:gift_grab/domain/notifiers/nakama_auth_notifier.dart';
import 'package:gift_grab/domain/notifiers/nakama_session_data_notifier.dart';
import 'package:gift_grab/domain/notifiers/nakama_users_notifier.dart';
import 'package:gift_grab/domain/notifiers/selected_avatar_notifier.dart';
// import 'package:gift_grab/domain/notifiers/package_info_notifier.dart';
import 'package:gift_grab/presentation/games/gift_grab_flame_game.dart';
import 'package:gift_grab/data/configuration/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:nakama/nakama.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class Providers {
  static final ref = ProviderContainer();

  static final nakamaAuthProvider =
      AsyncNotifierProvider<NakamaAuthNotifier, bool>(NakamaAuthNotifier.new);

  static final nakamaLeaderboardProvider =
      AsyncNotifierProvider<NakamaLeaderboardNotifier, List<LeaderboardRecord>>(
          NakamaLeaderboardNotifier.new);

  static final nakamaUsersProvider =
      AsyncNotifierProvider<NakamaUsersNotifier, List<User>>(
          NakamaUsersNotifier.new);

  static final nakamaSessionDataProvider =
      AsyncNotifierProvider<NakamaSessionDataNotifier, SessionData?>(
          NakamaSessionDataNotifier.new);

  // static final packageInfoProvider =
  //     AsyncNotifierProvider<PackageInfoNotifier, PackageInfo>(
  //         PackageInfoNotifier.new);

  static final routerProvider = Provider<GoRouter>(
    (ref) {
      final nakamaAuthProvider = ref.watch(Providers.nakamaAuthProvider);
      final isAuthenticated = nakamaAuthProvider.value == true;
      return appRoutes(isAuthenticated);
    },
  );

  static final selectedAvatarProvider =
      NotifierProvider<SelectedAvatarNotifier, LottieAvatar?>(
          SelectedAvatarNotifier.new);

  static final giftGrabFlameGameProvider = Provider<GiftGrabFlameGame>(
    (ref) => GiftGrabFlameGame(),
  );
}
