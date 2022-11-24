import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/components/background_component.dart';
import 'package:gift_grab/components/gift_component.dart';
import 'package:gift_grab/components/ice_component.dart';
import 'package:gift_grab/components/santa_component.dart';
import 'package:gift_grab/constants/globals.dart';
import 'package:gift_grab/inputs/joystick.dart';

class GiftGrabGame extends FlameGame with HasDraggables, HasCollisionDetection {
  /// The Santa character who collects the gifts.
  final SantaComponent _santaComponent = SantaComponent(joystick: joystick);

  /// Background of snow landscape.
  final BackgroundComponent _backgroundComponent = BackgroundComponent();

  /// The first gift to collect.s
  final GiftComponent _giftComponent = GiftComponent();

  /// Number of presents Santa has grabbed.
  int score = 0;

  /// Text UI component for score.
  late TextComponent _scoreText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Preload audio files.
    await FlameAudio.audioCache.loadAll(
      [
        Globals.freezeSound,
        Globals.itemGrabSound,
      ],
    );

    // Add background.
    add(_backgroundComponent);

    // Add initial gift.
    add(_giftComponent);

    // Add ice blocks.
    add(IceComponent(startPosition: Vector2(200, 200)));
    add(IceComponent(startPosition: Vector2(size.x - 200, size.y - 200)));

    // Add santa.
    add(_santaComponent);

    // Add joystick.
    add(joystick);

    // Add ScreenHitBox for boundries for ice blocks.
    add(ScreenHitbox());

    // Configure TextComponent
    _scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(40, 40),
      textRenderer: TextPaint(
        style: TextStyle(color: BasicPalette.white.color, fontSize: 50),
      ),
    );

    // Add Score TextComponent.
    add(_scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update score on the screen.
    _scoreText.text = 'Score: $score';
  }
}
