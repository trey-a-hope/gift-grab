import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/constants/screens.dart';
import 'package:gift_grab/data/services/hive_service.dart';
import 'package:flame/game.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/games/gift_grab_game.dart';
import 'package:gift_grab/presentation/screens/game_over_screen.dart';
import 'package:gift_grab/presentation/screens/leaderboard_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';

import 'presentation/screens/login_screen.dart';

GiftGrabGame _giftGrabGame = GiftGrabGame();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.openHiveBox(boxName: 'settings');

  runApp(ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          Globals.isTablet = MediaQuery.of(context).size.width > 600;

          return GameWidget(
            initialActiveOverlays: [Screens.login.name],
            game: _giftGrabGame,
            overlayBuilderMap: {
              Screens.gameOver.name:
                  (BuildContext context, GiftGrabGame gameRef) =>
                      GameOverScreen(gameRef: gameRef),
              Screens.main.name: (BuildContext context, GiftGrabGame gameRef) =>
                  MainMenuScreen(gameRef: gameRef),
              Screens.login.name:
                  (BuildContext context, GiftGrabGame gameRef) =>
                      LoginScreen(gameRef: gameRef),
              Screens.leaderboard.name:
                  (BuildContext context, GiftGrabGame gameRef) =>
                      LeaderboardScreen(gameRef: gameRef),
            },
          );
        },
      ),
    ),
  ));
}
