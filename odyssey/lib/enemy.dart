import "dart:math";
import "package:flame/components.dart";
import "package:flame/collisions.dart";

import "odyssey_game.dart";
import "bullet.dart";
import "explosion.dart";
import "player.dart";

class Enemy extends SpriteComponent
    with HasGameRef<OdysseyGame>, CollisionCallbacks {
  final random = Random();
  late int xDirection;
  late int yDirection;
  late int xSpeedFactor;
  late int ySpeedFactor;
  late final SpawnComponent _bulletSpawner;

  Enemy({super.key})
      : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
        );

  static const enemySize = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite("enemy0.png");
    add(RectangleHitbox());

    if (position.x >= game.size.x / 2) {
      if (random.nextInt(100) >= 20) {
        xDirection = -1;
      }
      else {
        xDirection = 1;
      }
    }
    else {
      if (random.nextInt(100) >= 20) {
        xDirection = 1;
      }
      else {
        xDirection = -1;
      }
    }

    xSpeedFactor = random.nextInt(400);
    ySpeedFactor = random.nextInt(400);

    yDirection = 1;

    _bulletSpawner = SpawnComponent(
      period: 1,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          image: "enemy_bullet0.png",
          yDirection: 1,
          position: position + Vector2(0, height),
        );
      },
    );
  
    game.add(_bulletSpawner);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 2% chance that speed will change
    if (random.nextInt(100) >= 98) {
      xSpeedFactor = random.nextInt(400);
    }
    if (random.nextInt(100) >= 98) {
      ySpeedFactor = random.nextInt(400);
    }

    // Calculate next position in order not to exceed screen boundary
    double nextx = position.x + dt * xDirection * xSpeedFactor;
    double nexty = position.y + dt * yDirection * ySpeedFactor;

    if (nextx <= 0 || nextx >= game.size.x) {
      xDirection *= -1;
    }
    if (nexty <= 0 || nexty >= game.size.y) {
      yDirection *= -1;
    }
    position.x += dt * xDirection * xSpeedFactor;
    position.y += dt * yDirection * ySpeedFactor;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      game.noEnemies -= 1;
      game.enemiesDestroyed += 1;
      game.overlays.remove("HUD");
      game.score += 40;  // Totaly random
      game.overlays.add("HUD");
      removeFromParent();
      other.removeFromParent();
      stopShooting();
      game.add(Explosion(position: position));
    } else if (other is Enemy) {
      if (random.nextInt(100) >= 50) {
        xDirection *= -1;
      } else {
        yDirection *= -1;
      }
    } else if (other is Player) {
      game.noEnemies -= 1;
      game.enemiesDestroyed += 1;
      game.overlays.remove("HUD");
      game.score += 40;  // Totaly random
      game.overlays.add("HUD");
      removeFromParent();
      stopShooting();
      game.add(Explosion(position: position));
    }
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }
}