enum MenuButton {
  deleteAccount(
    'Delete Account',
    null,
    'https://lottie.host/8b913c18-85c5-463b-b10c-fac2b6929560/GVjMdNNavH.json',
  ),
  editProfile(
    'Edit Profile',
    'edit_profile',
    'https://lottie.host/cf6238c1-ebcc-4741-a1c2-15098c620b83/xQETyKlA5A.json',
  ),
  groups(
    'Groups',
    'groups',
    'https://lottie.host/d05dca70-e470-4284-ad79-4cc78ae8c6fa/2TJKChtOeY.json',
  ),
  leaderboard(
    'Leaderboard',
    'leaderboard',
    'https://lottie.host/76d5c302-05ec-4aff-ac6c-3f73832201a9/VBsN3v28u9.json',
  ),
  linkedAccounts(
    'Linked Accounts',
    'linked_accounts',
    'https://lottie.host/c949d875-6223-4e7e-8eb0-dec46cca9f2b/JN9abpQohW.json',
  ),
  play(
    'Play',
    'game',
    'https://lottie.host/afa5e507-7b25-40e2-8cf9-07c7c63bace0/07iIcuc1gh.json',
  ),
  profile(
    'Profile',
    'profile',
    'https://lottie.host/ac2d1c3e-cd3d-4463-955a-f71f08033540/49dcqrxHYZ.json',
  ),
  settings(
    'Settings',
    'settings',
    'https://lottie.host/53e7c57a-d551-4e51-ba85-9d19aff299d9/Z776NgU1PR.json',
  ),
  signOut(
    'Sign Out',
    null,
    'https://lottie.host/f88e459d-6b62-4d0f-a98c-c496fb0c325e/2gJWApc9pg.json',
  );

  final String name;
  final String? route;
  final String lottieUrl;

  const MenuButton(
    this.name,
    this.route,
    this.lottieUrl,
  );
}
