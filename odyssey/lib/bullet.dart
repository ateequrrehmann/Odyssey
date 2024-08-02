import "package:flame/components.dart";
import "package:flame/collisions.dart";

import "odyssey_game.dart";

class Bullet extends SpriteComponent with HasGameRef<OdysseyGame> {
  Bullet({required this.image, required this.yDirection, super.position})
      : super(
          size: Vector2(25, 50),
          anchor: Anchor.center,
        );
  
  final String image;
  final int yDirection;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(image);
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += dt * yDirection * 500;

    if (position.y < 0 || position.y > game.size.y) {
      removeFromParent();
    }
  }
}