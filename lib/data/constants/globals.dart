class Globals {
  Globals._();

  static final nakamaConfig = _NakamaConfig();
  static final routes = _Routes();
  static final timeLimits = _TimeLimits();

  /// Audio
  static const String freezeSound = 'freeze-sound.wav';
  static const String itemGrabSound = 'item-grab-sound.wav';
  static const String flameSound = 'flame-sound.wav';

  static const String emptyProfile =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

  /// Images
  static const String santaIdle = 'santa-idle.png';
  static const String santaFrozen = 'santa-frozen.png';
  static const String santaSlideLeftSprite = 'santa-slide-left.png';
  static const String santaSlideRightSprite = 'santa-slide-right.png';
  static const String backgroundSprite = 'background-sprite.jpg';
  static const String giftSprite = 'gift-sprite.png';
  static const String iceSprite = 'ice-sprite.png';
  static const String flameSprite = 'flame.png';
  static const String cookieSprite = 'cookie.png';

  static late bool isTablet;

  /// One hour from now duration; used for token expiration.
  static final inOneHour = DateTime.now().add(
    const Duration(
      hours: 1,
    ),
  );
}

class _Routes {
  final String main = 'main';
  final String game = 'game';
  final String login = 'login';
  final String leaderboard = 'leaderboard';
  final String settings = 'settings';
  final String editProfile = 'edit_profile';
  final String pickAvatar = 'pick_avatar';
}

class _TimeLimits {
  final int round = 30;
  final int frozen = 3;
  final int flame = 10;
  final int cookie = 10;
}

enum LottieAvatar {
  candyCane('candy_cane', 'Candy Cane', 'assets/lotties/candy_cane.json'),
  present('present', 'Present', 'assets/lotties/present.json');

  const LottieAvatar(
    this.name,
    this.displayName,
    this.path,
  );

  final String name;
  final String displayName;
  final String path;

  static LottieAvatar? findByName(String? name) {
    switch (name) {
      case 'candy_cane':
        return LottieAvatar.candyCane;
      case 'present':
        return LottieAvatar.present;
    }

    return null;
  }
}

class _NakamaConfig {
  static const bool _isLocal = false;

  final String host = _isLocal ? '127.0.0.1' : '24.144.85.68';

  final int httpPort = 7351;

  final String serverKey = 'defaultkey';

  final bool ssl = false;

  final String avatarsCollection = 'avatars';
  final String avatarDoc = 'avatar';
}
