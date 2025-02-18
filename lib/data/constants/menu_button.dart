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
  play(
    'Play',
    Globals.lottiePlay,
  ),
  profile(
    'Profile',
    Globals.lottieProfile,
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
