import 'package:flame/components.dart';
import 'package:flame/palette.dart' as palette;
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/domain/blocs/game/game_bloc.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';

class HUDTextComponents extends PositionComponent
    with HasGameRef<GiftGrabGame>, FlameBlocListenable<GameBloc, GameState> {
  late TextComponent _scoreText;
  late TextComponent _timerText;
  late TextComponent _flameTimerText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _timerText = TextComponent(
      text: 'Time: 0',
      position: Vector2(40, 50),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          color: palette.BasicPalette.white.color,
          fontSize: 25,
        ),
      ),
    );

    _scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(gameRef.size.x - 40, 50),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: palette.BasicPalette.white.color,
          fontSize: 25,
        ),
      ),
    );

    _flameTimerText = TextComponent(
      text: 'Flame Time: 0',
      position: Vector2(gameRef.size.x - 40, 100),
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
  void onNewState(GameState state) {
    _scoreText.text = 'Score: ${state.score}';
    _timerText.text = 'Time: ${state.remainingTime}';

    if (state.isSantaFlamed) {
      // Check this instead of isFlameActive
      if (!_flameTimerText.isMounted) {
        add(_flameTimerText);
      }
      _flameTimerText.text = 'Flame Time: ${state.flameRemainingTime}';
    } else if (_flameTimerText.isMounted) {
      _flameTimerText.removeFromParent();
    }
  }
}
