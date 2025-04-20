import 'package:flame/components.dart';
import 'package:gift_grab/presentation/game/gift_grab_game.dart';
import 'package:gift_grab/data/constants/globals.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameReference<GiftGrabGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite(Globals.backgroundSprite);
    size = game.size;
  }
}
