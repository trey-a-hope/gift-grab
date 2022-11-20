import 'package:flame/components.dart';
import 'package:gift_grab/constants/globals.dart';
import 'package:gift_grab/games/gift_grab_game.dart';

class PlayerComponent extends SpriteComponent with HasGameRef<GiftGrabGame> {
  final double spriteHeight = 200;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.playerSprite);

    position = gameRef.size / 2;
    width = spriteHeight * 1.42;
    height = spriteHeight;
    anchor = Anchor.center;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}
