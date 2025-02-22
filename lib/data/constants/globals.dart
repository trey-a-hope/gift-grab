import 'package:cloudinary/cloudinary.dart';

class Globals {
  Globals._();

  // Lottie urls.
  static const lottieFriends =
      'https://lottie.host/1741de59-5532-45e4-b3f7-00ba3cfa92ad/0RBy5DNOHl.json';

  static const lottieChat =
      'https://lottie.host/d2d2b81d-e378-4842-b525-3f0d1bd72897/0z7ilexIZ9.json';

  static const lottieDeleteAccount =
      'https://lottie.host/8b913c18-85c5-463b-b10c-fac2b6929560/GVjMdNNavH.json';

  static const lottieGroups =
      'https://lottie.host/d05dca70-e470-4284-ad79-4cc78ae8c6fa/2TJKChtOeY.json';

  static const lottieLeaderboard =
      'https://lottie.host/76d5c302-05ec-4aff-ac6c-3f73832201a9/VBsN3v28u9.json';

  static const lottieLinkedAccounts =
      'https://lottie.host/c949d875-6223-4e7e-8eb0-dec46cca9f2b/JN9abpQohW.json';

  static const lottiePlay =
      'https://lottie.host/afa5e507-7b25-40e2-8cf9-07c7c63bace0/07iIcuc1gh.json';

  static const lottieProfile =
      'https://lottie.host/ac2d1c3e-cd3d-4463-955a-f71f08033540/49dcqrxHYZ.json';

  static const lottieSignOut =
      'https://lottie.host/f88e459d-6b62-4d0f-a98c-c496fb0c325e/2gJWApc9pg.json';

  static const lottieTournament =
      'https://lottie.host/e530bc24-55b7-4718-a153-0e7085a94b50/DKrp8UNP49.json';

  static const lottieNotifications =
      'https://lottie.host/24b01879-03f1-44b2-bbef-427321e5a4f8/WY0iLNz97c.json';

  static const lottieUsers =
      'https://lottie.host/e149d804-8452-4699-ad4f-32f48809a614/I8NzWu6KKY.json';

  // Limits
  static const int paginationLimit = 20;
  static const int gameTimeLimit = 10;

  static final cloudinaryConfig = Cloudinary.signedConfig(
    apiKey: '122467624349353',
    apiSecret: 'EDmkapThOKoGGKKjKN4CYWPcPg8',
    cloudName: 'dp6gsfu5c',
  );

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
}

class _TimeLimits {
  final int frozen = 3;
  final int cookie = 10;
}
