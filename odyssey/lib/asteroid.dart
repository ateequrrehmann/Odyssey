import "dart:math";

import "package:flame/components.dart";
import "package:flame/collisions.dart";

import "odyssey_game.dart";
import "bullet.dart";
import "explosion.dart";
import "player.dart";
import "collectable.dart";

class Asteroid extends SpriteComponent
    with HasGameRef<OdysseyGame>, CollisionCallbacks {
  Asteroid({super.position, required this.image, required this.asteroidSize})
      : super(size: asteroidSize, anchor: Anchor.center);

  final String image;
  final Vector2 asteroidSize;
  final Random random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(image);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += dt * 400;
    if (position.y > game.size.y) {
      // Managing the number of spawned asteroids here allows for
      // asteroids to go completely off screen before the level is
      // considered over
      game.spawnedAsteroids += 1;
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      // Managing the number of spawned asteroids here allows for
      // asteroids to go completely off screen before the level is
      // considered over
      game.spawnedAsteroids += 1;
      removeFromParent();
      other.removeFromParent();
      // Insert collectables in random asteroids
      game.add(Explosion(position: position));
      if (random.nextInt(4) == 1) {
        game.add(Collectable(
            image: "collectable1.png", type: "ruby", position: position));
      }
    } else if (other is Player) {
      // Managing the number of spawned asteroids here allows for
      // asteroids to go completely off screen before the level is
      // considered over
      game.spawnedAsteroids += 1;
      // Player manages health itself
      removeFromParent();
      game.add(Explosion(position: position));
    }
  }
}
