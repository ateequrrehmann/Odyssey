import "package:flame/components.dart";

import "odyssey_game.dart";

class Explosion extends SpriteAnimationComponent
    with HasGameRef<OdysseyGame> {
  Explosion({super.position})
      : super(
          size: Vector2.all(150),
          anchor: Anchor.center,
          removeOnFinish: true,
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      "explosion0_animates.png",
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.06,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
  }
}