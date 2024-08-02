import "package:flame/components.dart";
import "package:flame/collisions.dart";

import "odyssey_game.dart";

class Collectable extends SpriteComponent
    with HasGameRef<OdysseyGame>, CollisionCallbacks {
  Collectable({required this.image, required this.type, super.position})
      : super(size: Vector2(40, 40));

  final String image;
  final String type;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(image);
    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += dt * 200;
    if (position.y > game.size.y) {
      removeFromParent();
    }
  }
}
