enum MenuButton {
  liveChat(
    'Live Chat',
    'https://lottie.host/d2d2b81d-e378-4842-b525-3f0d1bd72897/0z7ilexIZ9.json',
  ),
  deleteAccount(
    'Delete Account',
    'https://lottie.host/8b913c18-85c5-463b-b10c-fac2b6929560/GVjMdNNavH.json',
  ),
  friends(
    'Friends',
    'https://lottie.host/1741de59-5532-45e4-b3f7-00ba3cfa92ad/0RBy5DNOHl.json',
  ),
  groups(
    'Groups',
    'https://lottie.host/d05dca70-e470-4284-ad79-4cc78ae8c6fa/2TJKChtOeY.json',
  ),
  leaderboard(
    'Leaderboard',
    'https://lottie.host/76d5c302-05ec-4aff-ac6c-3f73832201a9/VBsN3v28u9.json',
  ),
  linkedAccounts(
    'Linked Accounts',
    'https://lottie.host/c949d875-6223-4e7e-8eb0-dec46cca9f2b/JN9abpQohW.json',
  ),
  matches(
    'Matches',
    'https://lottie.host/2cfbbe8e-e22f-4564-a9c5-7b21c72ca1fb/EOLcfvGKwx.json',
  ),
  play(
    'Play',
    'https://lottie.host/afa5e507-7b25-40e2-8cf9-07c7c63bace0/07iIcuc1gh.json',
  ),
  profile(
    'Profile',
    'https://lottie.host/ac2d1c3e-cd3d-4463-955a-f71f08033540/49dcqrxHYZ.json',
  ),

  signOut(
    'Sign Out',
    'https://lottie.host/f88e459d-6b62-4d0f-a98c-c496fb0c325e/2gJWApc9pg.json',
  ),
  tournaments(
    'Tournaments',
    'https://lottie.host/2cfbbe8e-e22f-4564-a9c5-7b21c72ca1fb/EOLcfvGKwx.json',
  ),
  ;

  final String name;
  final String lottieUrl;

  const MenuButton(
    this.name,
    this.lottieUrl,
  );
}
