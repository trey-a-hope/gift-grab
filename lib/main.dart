import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/screens.dart';
import 'package:gift_grab/data/services/hive_service.dart';
import 'package:flame/game.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/games/gift_grab_game.dart';
import 'package:gift_grab/presentation/screens/game_over_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';

GiftGrabGame _giftGrabGame = GiftGrabGame();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.openHiveBox(boxName: 'settings');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          Globals.isTablet = MediaQuery.of(context).size.width > 600;

          return GameWidget(
            initialActiveOverlays: [Screens.main.name],
            game: _giftGrabGame,
            overlayBuilderMap: {
              Screens.gameOver.name:
                  (BuildContext context, GiftGrabGame gameRef) =>
                      GameOverMenu(gameRef: gameRef),
              Screens.main.name: (BuildContext context, GiftGrabGame gameRef) =>
                  MainMenu(gameRef: gameRef),
            },
          );
        },
      ),
    ),
  );
}
