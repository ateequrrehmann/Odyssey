import "package:flame/components.dart";
import "package:flame/collisions.dart";

import "odyssey_game.dart";
import "bullet.dart";
import "explosion.dart";
import "enemy.dart";
import "collectable.dart";
import "asteroid.dart";
import "power_up_collectable.dart";

class Player extends SpriteAnimationComponent
    with HasGameRef<OdysseyGame>, CollisionCallbacks {
  late SpawnComponent _bulletSpawner;

  Player()
      : super(
          size: Vector2(100, 78),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    animation = await game.loadSpriteAnimation(
      "spaceship0_animates.png",
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.05,
        textureSize: Vector2(382.2, 368),
      ),
    );

    add(RectangleHitbox());

    position = gameRef.size / 2;

    double fireRate = 0.5;
    if (game.fireRateIPowerUp) {
      fireRate -= 0.05;
    }
    if (game.fireRateIIPowerUp) {
      fireRate -= 0.05;
    }

    _bulletSpawner = SpawnComponent(
      period: fireRate,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          image: "player_bullet0.png",
          yDirection: -1,
          position: position + Vector2(0, -height),
        );
      },
      autoStart: false,
    );

    game.add(_bulletSpawner);
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if ((other is Bullet && other.yDirection == 1) ||
        other is Enemy ||
        other is Asteroid) {
      if (game.playerHealth <= 0) {
        // Game is over
        removeFromParent();
        other.removeFromParent();
        if (other is Enemy) {
          other.stopShooting();
        }
        game.add(Explosion(position: position));
        game.overlays.remove("HUD");
        for (var child in game.children) {
          // Avoid buggy behaviour when player is destroyed;
          // bullets and enemies still alive can trigger a level complete
          // event
          if (child is Bullet || child is Enemy) {
            if (child is Enemy) {
              child.stopShooting();
            }
            game.remove(child);
          }
        }
        if (!game.overlays.isActive("NextLevelMenu")) {
          // Prevent multiple overlays
          game.overlays.add("GameOverMenu");
        }
      } else {
        // Game is not over yet
        game.overlays.remove("HUD");
        int damage = 25;
        if (game.shieldCapacityIPowerUp) {
          damage -= 4;
        }
        if (game.shieldCapacityIIPowerUp) {
          damage -= 4;
        }
        if (game.shieldCapacityIIIPowerUp) {
          damage -= 4;
        }
        if (game.shieldCapacityIVPowerUp) {
          damage -= 4;
        }
        if (game.shieldCapacityVPowerUp) {
          damage -= 4;
        }
        if (game.shieldCapacityVIPowerUp) {
          damage -= 4;
        }
        game.playerHealth -= damage;
        if(game.playerHealth<1){
          game.playerHealth=0;
        }
        game.overlays.add("HUD");
        if (other is Bullet) {
          other.removeFromParent();
          game.add(Explosion(position: position));
        }
      }
    }
    if (other is Collectable) {
      game.overlays.remove("HUD");
      if (other.type == "gold") {
        game.creditsCollected += 10;
      } else if (other.type == "ruby") {
        game.creditsCollected += 100;
      }
      game.overlays.add("HUD");
      other.removeFromParent();
    }
    if (other is PowerUpCollectable) {
      if (other.type == "healPowerUp") {
        game.overlays.remove("HUD");
        game.playerHealth = 100;
        game.overlays.add("HUD");
      }
      if (other.type == "machineGunPowerUp") {
        _bulletSpawner.period = 0.2;
        _bulletSpawner.factory = (index) {
          return Bullet(
            image: "player_bullet1.png",
            yDirection: -1,
            position: position + Vector2(0, -height),
          );
        };
      }
      other.removeFromParent();
    }
  }
}
