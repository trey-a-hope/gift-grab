import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gift_grab/presentation/components/santa_component.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';
import 'dart:math' as math;

import 'package:gift_grab/data/constants/globals.dart';

class CookieComponent extends SpriteComponent
    with HasGameRef<GiftGrabGame>, CollisionCallbacks {
  final double _spriteHeight = Globals.isTablet ? 160.0 : 80.0;
  late Vector2 _velocity;
  double speed = Globals.isTablet ? 600 : 300;
  final double degree = math.pi / 180;

  final Vector2 startPosition;

  CookieComponent({
    required this.startPosition,
  });
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.cookieSprite);

    final double spawnAngle = _getSpawnAngle();
    final double vx = math.cos(spawnAngle * degree) * speed;
    final double vy = math.sin(spawnAngle * degree) * speed;
    _velocity = Vector2(vx, vy);

    width = _spriteHeight;
    height = _spriteHeight;
    anchor = Anchor.center;

    add(CircleHitbox()..radius = 1);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updatePosition(dt);
    _keepInBounds();
  }

  void _updatePosition(double dt) {
    position += _velocity * dt;
  }

  void _keepInBounds() {
    if (position.x < 0 || position.x > gameRef.size.x) {
      _velocity.x = -_velocity.x;
      position.x = position.x.clamp(0, gameRef.size.x);
    }
    if (position.y < 0 || position.y > gameRef.size.y) {
      _velocity.y = -_velocity.y;
      position.y = position.y.clamp(0, gameRef.size.y);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is SantaComponent) {
      removeFromParent();
    }
  }

  double _getSpawnAngle() {
    final random = math.Random().nextDouble();
    return lerpDouble(0, 360, random)!;
  }
}
