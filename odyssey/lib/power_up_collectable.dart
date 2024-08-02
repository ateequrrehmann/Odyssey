import "package:flame/components.dart";
import "package:flame/collisions.dart";

import "odyssey_game.dart";

class PowerUpCollectable extends SpriteComponent
    with HasGameRef<OdysseyGame>, CollisionCallbacks {
  PowerUpCollectable({
    required this.image,
    required this.type,
    required this.collectableSize,
    super.position,
  }) : super(size: collectableSize);

  final String image;
  final String type;
  final Vector2 collectableSize;

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
