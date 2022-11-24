import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/games/gift_grab_game.dart';

void main() async {
  final GiftGrabGame game = GiftGrabGame();

  runApp(GameWidget(game: game));
}
