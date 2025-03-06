import 'package:gift_grab/data/constants/globals.dart';

enum MenuButton {
  chatRooms(
    'Chat Rooms',
    Globals.lottieChat,
  ),
  deleteAccount(
    'Delete Account',
    Globals.lottieDeleteAccount,
  ),
  friends(
    'Friends',
    Globals.lottieFriends,
  ),
  editProfile(
    'Edit Profile',
    Globals.lottieEditProfile,
  ),
  groups(
    'Groups',
    Globals.lottieGroups,
  ),
  leaderboard(
    'Leaderboard',
    Globals.lottieLeaderboard,
  ),
  linkedAccounts(
    'Linked Accounts',
    Globals.lottieLinkedAccounts,
  ),
  notifications(
    'Notifications',
    Globals.lottieNotifications,
  ),
  play(
    'Play',
    Globals.lottiePlay,
  ),
  profile(
    'Profile',
    Globals.lottieProfile,
  ),
  searchUsers(
    'Search Users',
    Globals.lottieUsers,
  ),
  signOut(
    'Sign Out',
    Globals.lottieSignOut,
  ),
  tournaments(
    'Tournaments',
    Globals.lottieTournament,
  ),
  ;

  final String name;
  final String lottieUrl;

  const MenuButton(
    this.name,
    this.lottieUrl,
  );
}
