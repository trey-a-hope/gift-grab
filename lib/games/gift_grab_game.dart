import 'package:flame/game.dart';
import 'package:gift_grab/components/background_component.dart';
import 'package:gift_grab/components/player_component.dart';
import 'package:gift_grab/inputs/joystick.dart';

class GiftGrabGame extends FlameGame with HasDraggables {
  final PlayerComponent _playerComponent = PlayerComponent(joystick: joystick);
  final BackgroundComponent _backgroundComponent = BackgroundComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add background.
    add(_backgroundComponent);

    // Add player component.
    add(_playerComponent);

    // Add joystick.
    add(joystick);
  }
}
