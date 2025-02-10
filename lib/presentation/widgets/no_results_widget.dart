import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const friendsLottie =
    'https://lottie.host/1741de59-5532-45e4-b3f7-00ba3cfa92ad/0RBy5DNOHl.json';
const groupsLottie =
    'https://lottie.host/d05dca70-e470-4284-ad79-4cc78ae8c6fa/2TJKChtOeY.json';
const notificationsLottie =
    'https://lottie.host/24b01879-03f1-44b2-bbef-427321e5a4f8/WY0iLNz97c.json';
const matchesLottie =
    'https://lottie.host/2cfbbe8e-e22f-4564-a9c5-7b21c72ca1fb/EOLcfvGKwx.json';
const usersLottie =
    'https://lottie.host/e149d804-8452-4699-ad4f-32f48809a614/I8NzWu6KKY.json';

const tournamentLottie =
    'https://lottie.host/e530bc24-55b7-4718-a153-0e7085a94b50/DKrp8UNP49.json';

// TODO: Join with values set in menu_button.dart.
enum NoResultsEnum {
  chatRooms('No chat rooms', friendsLottie),

  // Friends
  blocks('No blocks', friendsLottie),
  friends('No friends', friendsLottie),
  invites('No invites', friendsLottie),
  requests('No requests', friendsLottie),
  // Groups
  allGroups('No groups', groupsLottie),
  myGroups('No groups you belong to', groupsLottie),
  // Matches
  matches('No matches', friendsLottie),
  // Tournament
  tournaments('No tournaments', friendsLottie),
  tournament('No records', tournamentLottie),

  // Notifications
  notifications('No notifications', notificationsLottie),
  // Leaderboard
  leaderboard('No records for this week',
      'https://lottie.host/76d5c302-05ec-4aff-ac6c-3f73832201a9/VBsN3v28u9.json'),
  // Users
  users('No users found', usersLottie);

  final String lottieUrl;
  final String name;

  const NoResultsEnum(
    this.name,
    this.lottieUrl,
  );
}

class NoResultsWidget extends StatelessWidget {
  final NoResultsEnum type;

  const NoResultsWidget(this.type, {super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(type.lottieUrl, height: 200),
          Text(type.name, style: Theme.of(context).textTheme.displayLarge),
        ],
      );
}
