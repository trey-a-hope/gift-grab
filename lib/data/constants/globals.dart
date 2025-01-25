import 'package:cloudinary/cloudinary.dart';

class Globals {
  Globals._();

  static int paginationLimit = 20;
  static const int gameTimeLimit = 10;

  static final cloudinaryConfig = Cloudinary.signedConfig(
    apiKey: '122467624349353',
    apiSecret: 'EDmkapThOKoGGKKjKN4CYWPcPg8',
    cloudName: 'dp6gsfu5c',
  );
  static final routes = _Routes();
  static final timeLimits = _TimeLimits();
  static final rpc = _RPCFunctions();

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

  static bool isTablet = true; // TODO: Handle this check...

  /// One hour from now duration; used for token expiration.
  static final inOneHour = DateTime.now().add(
    const Duration(
      hours: 1,
    ),
  );
}

class _Routes {
  final String main = 'main';
  final String login = 'login';
  final String game = 'game';
  final String leaderboard = 'leaderboard';
  final String settings = 'settings';
  final String editProfile = 'edit_profile';
  final String groups = 'groups';
  final String createGroup = 'create_group';
  final String groupDetails = 'group_details';
  final String editGroup = 'edit_group';
  final String profile = 'profile';
  final String linkedAccounts = 'linked_accounts';
  final String notifications = 'notifications';
  final String friends = 'friends';
  final String searchUsers = 'search_users';
}

class _TimeLimits {
  // final int round = 30;
  final int frozen = 3;
  // final int flame = 10;
  final int cookie = 10;
}

class _RPCFunctions {
  final notificationSend = 'notification_send';
  final accountDeleteId = 'account_delete_id';
}
