import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gift_grab/constants/globals.dart';
import 'package:gift_grab/games/gift_grab_game.dart';

class PlayerComponent extends SpriteComponent
    with HasGameRef<GiftGrabGame>, CollisionCallbacks {
  final double _spriteHeight = 200.0;
  final double _maxSpeed = 300.0;
  final JoystickComponent joystick;

  PlayerComponent({required this.joystick});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Globals.playerSprite);
    position = gameRef.size / 2;
    width = _spriteHeight * 1.42;
    height = _spriteHeight;
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (joystick.direction != JoystickDirection.idle) {
      position.add(joystick.relativeDelta * _maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
  }
}
