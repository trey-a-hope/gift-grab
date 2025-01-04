import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:gift_grab/domain/blocs/game/game_bloc.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/components/gift_component.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';
import 'package:gift_grab/presentation/components/cookie_component.dart';
import 'package:gift_grab/presentation/components/flame_component.dart';
import 'package:gift_grab/presentation/components/ice_component.dart';

enum MovementState {
  idle,
  slideLeft,
  slideRight,
  frozen,
}

class SantaComponent extends SpriteGroupComponent<MovementState>
    with
        HasGameRef<GiftGrabGame>,
        CollisionCallbacks,
        FlameBlocReader<GameBloc, GameState> {
  final double _spriteHeight = 200;
  final JoystickComponent joystick;

  late double _rightBound;
  late double _leftBound;
  late double _upBound;
  late double _downBound;

  SantaComponent({
    required this.joystick,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load sprites
    final Sprite santaIdle = await gameRef.loadSprite(Globals.santaIdle);
    final Sprite santaSlideLeft =
        await gameRef.loadSprite(Globals.santaSlideLeftSprite);
    final Sprite santaSlideRight =
        await gameRef.loadSprite(Globals.santaSlideRightSprite);
    final Sprite santaFrozen = await gameRef.loadSprite(Globals.santaFrozen);

    sprites = {
      MovementState.idle: santaIdle,
      MovementState.slideLeft: santaSlideLeft,
      MovementState.slideRight: santaSlideRight,
      MovementState.frozen: santaFrozen,
    };

    // Set boundaries
    _rightBound = gameRef.size.x - 45;
    _leftBound = 0 + 45;
    _upBound = 0 + 55;
    _downBound = gameRef.size.y - 55;

    // Set dimensions
    width = _spriteHeight * 1.42;
    height = _spriteHeight;
    anchor = Anchor.center;

    position = gameRef.size / 2;
    current = MovementState.idle;

    add(CircleHitbox()..radius = 1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (bloc.state.isSantaFrozen) {
      current = MovementState.frozen;
    } else {
      if (joystick.direction == JoystickDirection.idle) {
        current = MovementState.idle;
      } else {
        // Handle boundaries
        if (x >= _rightBound) x = _rightBound - 1;
        if (x <= _leftBound) x = _leftBound + 1;
        if (y >= _downBound) y = _downBound - 1;
        if (y <= _upBound) y = _upBound + 1;

        // Update movement state
        bool moveLeft = joystick.relativeDelta[0] < 0;
        current = moveLeft ? MovementState.slideLeft : MovementState.slideRight;

        // Update position
        position += joystick.relativeDelta * bloc.state.santaSpeed * dt;
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is IceComponent &&
        !bloc.state.isSantaFlamed &&
        !bloc.state.isSantaFrozen) {
      _handleIceCollision();
    } else if (other is FlameComponent) {
      _handleFlameCollision();
    } else if (other is CookieComponent) {
      _handleCookieCollision();
    } else if (other is GiftComponent) {
      _handleGiftCollision();
    }
  }

  void _handleIceCollision() {
    bloc.add(FreezeSantaEvent());
    FlameAudio.play(Globals.freezeSound);
  }

  void _handleFlameCollision() {
    if (!bloc.state.isSantaFrozen) {
      bloc.add(StartFlameCountdownEvent());
      FlameAudio.play(Globals.flameSound);
    }
  }

  void _handleCookieCollision() {
    bloc.add(IncreaseSantaSpeedEvent());
    FlameAudio.play(Globals.itemGrabSound);
  }

  void _handleGiftCollision() {
    bloc.add(ScorePointEvent());
    FlameAudio.play(Globals.itemGrabSound);
  }
}
