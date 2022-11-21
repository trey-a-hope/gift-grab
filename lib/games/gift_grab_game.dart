import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:gift_grab/components/background_component.dart';
import 'package:gift_grab/components/gift_component.dart';
import 'package:gift_grab/components/player_component.dart';
import 'package:gift_grab/inputs/joystick.dart';

class GiftGrabGame extends FlameGame with HasDraggables, HasCollisionDetection {
  final PlayerComponent _playerComponent = PlayerComponent(joystick: joystick);
  final BackgroundComponent _backgroundComponent = BackgroundComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final GiftComponent giftComponent = GiftComponent();

    // Add background.
    add(_backgroundComponent);

    add(giftComponent);

    // Add player component.
    add(_playerComponent);

    add(ScreenHitbox());

    // Add joystick.
    add(joystick);
  }
}
