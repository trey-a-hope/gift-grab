class Globals {
  Globals._();

  static final nakamaConfig = _NakamaConfig();

  /// Routes
  static const String routeMain = 'main';
  static const String routeGame = 'game';
  static const String routeLogin = 'login';
  static const String routeLeaderboard = 'leaderboard';

  /// Audio
  static const String freezeSound = 'freeze-sound.wav';
  static const String itemGrabSound = 'item-grab-sound.wav';
  static const String flameSound = 'flame-sound.wav';

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

  static const int gameTimeLimit = 3;
  static const int frozenTimeLimit = 3;
  static const int flameTimeLimit = 10;
  static const int cookieTimeLimit = 10;

  /// One hour from now duration; used for token expiration.
  static final inOneHour = DateTime.now().add(
    const Duration(
      hours: 1,
    ),
  );
}

class _NakamaConfig {
  static const bool isDebug = true;

  final String host = isDebug ? '127.0.0.1' : '24.144.85.68';

  final int httpPort = 7351;

  final String serverKey = 'defaultkey';

  final bool ssl = false;
}
