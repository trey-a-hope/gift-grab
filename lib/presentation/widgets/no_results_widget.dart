import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:lottie/lottie.dart';

enum NoResultsEnum {
  // Chat
  chatRooms('No chat rooms', Globals.lottieFriends),
  // Friends
  blocked('No blocks', Globals.lottieFriends),
  mutual('No friends', Globals.lottieFriends),
  incomingRequest('No invites', Globals.lottieFriends),
  outgoingRequest('No requests', Globals.lottieFriends),
  // Groups
  allGroups('No groups', Globals.lottieGroups),
  myGroups('No groups you belong to', Globals.lottieGroups),
  // Tournament
  tournaments('No tournaments', Globals.lottieFriends),
  tournament('No records', Globals.lottieTournament),
  // Notifications
  notifications('No notifications', Globals.lottieNotifications),
  // Leaderboard
  leaderboard('No records for this week', Globals.lottieLeaderboard),
  // Users
  users('No users found', Globals.lottieUsers);

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
