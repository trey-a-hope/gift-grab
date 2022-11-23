import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gift_grab/components/santa_component.dart';
import 'package:gift_grab/constants/globals.dart';
import 'package:gift_grab/games/gift_grab_game.dart';
import 'dart:math';

class GiftComponent extends SpriteComponent
    with HasGameRef<GiftGrabGame>, CollisionCallbacks {
  /// Height of the sprite.
  final double _spriteHeight = 200.0;

  /// Speed of the gift.
  final double speed = 500;

  /// Used for generating random position of gift.
  final Random _random = Random();

  GiftComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.giftSprite);

    position = _createRandomPosition();

    // Set dimensions of santa sprite.
    width = _spriteHeight;
    height = _spriteHeight;

    // Set anchor of component.
    anchor = Anchor.center;

    add(CircleHitbox()..radius = 1);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is SantaComponent) {
      // Remove the just collided gift.
      removeFromParent();

      //TODO: Add to players score.

      // Add a new gift to the field.
      gameRef.add(GiftComponent());
    }
  }

  /// Create new position for the gift on random.
  Vector2 _createRandomPosition() {
    final double x = _random.nextInt(gameRef.size.x.toInt()).toDouble();
    final double y = _random.nextInt(gameRef.size.y.toInt()).toDouble();

    return Vector2(x, y);
  }
}
