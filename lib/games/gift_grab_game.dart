import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:gift_grab/components/player_component.dart';

class GiftGrabGame extends FlameGame with PanDetector {
  final PlayerComponent _playerComponent = PlayerComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(_playerComponent);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _playerComponent.move(info.delta.game);
  }
}
