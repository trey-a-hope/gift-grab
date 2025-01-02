import 'package:flame/components.dart';
import 'package:flame/palette.dart' as palette;
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/domain/blocs/game/game_bloc.dart';
import 'package:gift_grab/domain/blocs/game/game_state.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';

class HUDTextComponents extends PositionComponent
    with HasGameRef<GiftGrabGame>, FlameBlocReader<GameBloc, GameState> {
  late TextComponent _scoreText;
  late TextComponent _timerText;
  late TextComponent _flameTimerText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _timerText = TextComponent(
      text: 'Time: ${bloc.state.remainingTime}',
      position: Vector2(40, 50), // Left side
      anchor: Anchor.topLeft, // Anchor to top-left
      textRenderer: TextPaint(
        style: TextStyle(
          color: palette.BasicPalette.white.color,
          fontSize: 25,
        ),
      ),
    );

    _scoreText = TextComponent(
      text: 'Score: ${bloc.state.score}',
      position: Vector2(gameRef.size.x - 40, 50), // Right side
      anchor: Anchor.topRight, // Anchor to top-right
      textRenderer: TextPaint(
        style: TextStyle(
          color: palette.BasicPalette.white.color,
          fontSize: 25,
        ),
      ),
    );

    _flameTimerText = TextComponent(
      text: 'Flame Time: ${bloc.state.flameRemainingTime}',
      position: Vector2(gameRef.size.x - 40, 100), // Below score on right
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: palette.BasicPalette.white.color,
          fontSize: 25,
        ),
      ),
    );

    add(_timerText);
    add(_scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _scoreText.text = 'Score: ${bloc.state.score}';
    _timerText.text = 'Time: ${bloc.state.remainingTime}';

    if (bloc.state.isFlameActive) {
      if (!_flameTimerText.isMounted) {
        add(_flameTimerText);
      }
      _flameTimerText.text = 'Flame Time: ${bloc.state.flameRemainingTime}';
    } else if (_flameTimerText.isMounted) {
      _flameTimerText.removeFromParent();
    }
  }
}
