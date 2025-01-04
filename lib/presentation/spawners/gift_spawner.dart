import 'dart:math';
import 'package:flame/components.dart';
import 'package:gift_grab/presentation/components/gift_component.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';

class GiftSpawner extends Component with HasGameRef<GiftGrabGame> {
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _spawnGift(); // Spawn the first gift as soon as the spawner loads
  }

  void _spawnGift() {
    final randomPosition = _createRandomPosition();
    add(GiftComponent(
      startPosition: randomPosition,
      onCollected: () {
        // Spawn a new gift immediately when the current one is collected
        _spawnGift();
      },
    ));
  }

  Vector2 _createRandomPosition() {
    return Vector2(
      _random.nextDouble() * gameRef.size.x,
      _random.nextDouble() * gameRef.size.y,
    );
  }
}
