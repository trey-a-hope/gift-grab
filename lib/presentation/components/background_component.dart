import 'package:flame/components.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';
import 'package:gift_grab/data/constants/globals.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameRef<GiftGrabGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Globals.backgroundSprite);
    size = gameRef.size;
  }
}
