import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:gift_grab/components/background_component.dart';
import 'package:gift_grab/components/gift_component.dart';
import 'package:gift_grab/components/ice_component.dart';
import 'package:gift_grab/components/santa_component.dart';
import 'package:gift_grab/inputs/joystick.dart';

class GiftGrabGame extends FlameGame with HasDraggables, HasCollisionDetection {
  /// The Santa character who collects the gifts.
  final SantaComponent _santaComponent = SantaComponent(joystick: joystick);

  /// Background of snow landscape.
  final BackgroundComponent _backgroundComponent = BackgroundComponent();

  /// The first gift to collect.s
  final GiftComponent _giftComponent = GiftComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add background.
    add(_backgroundComponent);

    // Add initial gift.
    add(_giftComponent);

    //  Add ice blocks.
    add(IceComponent(startPosition: Vector2(200, 200)));
    add(IceComponent(startPosition: Vector2(size.x - 200, size.y - 200)));

    // Add santa.
    add(_santaComponent);

    // Add joystick.
    add(joystick);

    // Add ScreenHitBox for boundries for ice blocks.
    add(ScreenHitbox());
  }
}
