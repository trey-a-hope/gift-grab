import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gift_grab/presentation/components/santa_component.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'dart:math' as math;

class GiftComponent extends SpriteComponent
    with HasGameRef<GiftGrabGame>, CollisionCallbacks {
  static const double TABLET_HEIGHT = 200.0;
  static const double MOBILE_HEIGHT = 100.0;
  static const double TABLET_SPEED = 250.0; // Slightly slower than flame
  static const double MOBILE_SPEED = 125.0;
  static const double SIZE_RATIO = 1.0;

  late final Vector2 _velocity;
  final Vector2 startPosition;
  final double _spriteHeight;
  final double speed;
  final Function onCollected;

  GiftComponent({
    required this.startPosition,
    required this.onCollected,
  })  : _spriteHeight = Globals.isTablet ? TABLET_HEIGHT : MOBILE_HEIGHT,
        speed = Globals.isTablet ? TABLET_SPEED : MOBILE_SPEED;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _setupSprite();
    _setupPhysics();
    _setupCollision();
  }

  Future<void> _setupSprite() async {
    sprite = await gameRef.loadSprite(Globals.giftSprite);
    width = _spriteHeight * SIZE_RATIO;
    height = _spriteHeight;
    anchor = Anchor.center;
  }

  void _setupPhysics() {
    position = startPosition;
    _velocity = _calculateInitialVelocity();
  }

  void _setupCollision() {
    add(CircleHitbox()..radius = width / 2);
    add(ScreenHitbox());
  }

  Vector2 _calculateInitialVelocity() {
    final double angle = _getRandomAngle() * (math.pi / 180);
    return Vector2(
      math.cos(angle) * speed,
      math.sin(angle) * speed,
    );
  }

  double _getRandomAngle() => lerpDouble(0, 360, math.Random().nextDouble())!;

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
      FlameAudio.play(Globals.itemGrabSound);
      removeFromParent();
      onCollected();
    }
  }
}
