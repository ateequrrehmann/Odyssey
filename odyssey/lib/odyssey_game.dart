import "dart:math";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flame/events.dart";
import "package:flame/game.dart";
import "package:flame/components.dart";
import "package:flame/input.dart";
import "package:flame/parallax.dart";
import "package:flame/experimental.dart";
import "package:odyssey/bullet.dart";

import "player.dart";
import "enemy.dart";
import "collectable.dart";
import "asteroid.dart";
import "power_up_collectable.dart";




class OdysseyGame extends FlameGame
    with PanDetector, HasCollisionDetection, SingleGameInstance {
  late int totalEnemies; // Number of enemies in one level
  final int enemiesAllowed = 4; // Enemies allowed per screen
  late int totalAsteroids; // Total asteroids allowed per level
  int spawnedAsteroids = 0; // Total asteroids spawned
  // Parallax images are stored in a list on the off chance that
  // different images may be used some day
  late List<String> parallaxImages;
  late Player player;
  late final SpawnComponent _enemySpawner;
  late final SpawnComponent _collectableSpawner;
  late final SpawnComponent _asteroidSpawner;
  late final SpawnComponent _healPowerUpSpawner;
  late final SpawnComponent _machineGunPowerUpSpawner;
  List<String> unlockedItems = [];
  int noEnemies = 0; // Number of enemies currently on the screen
  Random random = Random();
  int enemiesSpawned = 0; // Enemies spawned in one level
  int enemiesDestroyed = 0;
  late ParallaxComponent parallax;
  int score = 0;
  late int level;
  late int highestScore;
  late int highestLevel;
  late bool gameStarted;
  late int playerHealth;
  late int creditsCollected;
  // Power ups
  late bool shieldCapacityIPowerUp;
  late bool shieldCapacityIIPowerUp;
  late bool shieldCapacityIIIPowerUp;
  late bool shieldCapacityIVPowerUp;
  late bool shieldCapacityVPowerUp;
  late bool shieldCapacityVIPowerUp;
  late bool fireRateIPowerUp;
  late bool fireRateIIPowerUp;
  late bool healPowerUp;
  late bool machineGunPowerUp;
  late String userId;
  @override
  Future<void> onLoad() async {
    await super.onLoad();


    //fetchUserData();

    // Generate info for first level
    totalEnemies = random.nextInt(4) + 4;
    totalAsteroids = 1000; // This is only a place holder
    parallaxImages = ["stars0.png", "stars1.png", "stars2.png"];

    gameStarted = false;
    playerHealth = 100;

    _enemySpawner = SpawnComponent(
      factory: (index) {
        noEnemies += 1;
        enemiesSpawned += 1;
        return Enemy();
      },
      period: 1,
      area: Rectangle.fromLTWH(0, 0, size.x, 0),
    );

    _collectableSpawner = SpawnComponent.periodRange(
      factory: (index) {
        if (random.nextInt(25) == 1) {
          // Higher value collectable
          return Collectable(image: "collectable1.png", type: "ruby");
        }
        return Collectable(image: "collectable0.png", type: "gold");
      },
      minPeriod: 2,
      maxPeriod: 10,
      area: Rectangle.fromLTWH(0, 0, size.x, 0),
    );

    _asteroidSpawner = SpawnComponent.periodRange(
      factory: (index) {
        double asteroidSizeXY = random.nextInt(240) + 40;
        return Asteroid(
          image: "asteroid0.png",
          asteroidSize: Vector2.all(asteroidSizeXY),
        );
      },
      minPeriod: 0.4,
      maxPeriod: 0.8,
      area: Rectangle.fromLTWH(0, 0, size.x, 0),
    );

    _healPowerUpSpawner = SpawnComponent.periodRange(
      factory: (index) {
        return PowerUpCollectable(
          image: "heal_collectable.png",
          type: "healPowerUp",
          collectableSize: Vector2.all(40),
        );
      },
      minPeriod: 2,
      maxPeriod: 10,
      area: Rectangle.fromLTWH(0, 0, size.x, 0),
    );

    _machineGunPowerUpSpawner = SpawnComponent.periodRange(
      factory: (index) {
        return PowerUpCollectable(
          image: "machine_gun_collectable.png",
          type: "machineGunPowerUp",
          collectableSize: Vector2(100, 40),
        );
      },
      minPeriod: 4,
      maxPeriod: 40,
      area: Rectangle.fromLTWH(0, 0, size.x, 0),
    );

    parallax = await loadParallaxComponent(
      [
        ParallaxImageData(parallaxImages[0]),
        ParallaxImageData(parallaxImages[1]),
        ParallaxImageData(parallaxImages[2]),
      ],
      baseVelocity: Vector2(0, -1),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 4),
    );
    add(parallax);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameStarted == false) {
      return;
    }
    if (noEnemies >= enemiesAllowed || enemiesSpawned == totalEnemies) {
      _enemySpawner.timer.pause();
    }
    if (noEnemies == 0) {
      _enemySpawner.timer.resume();
    }



    // Level complete
    if (enemiesDestroyed == totalEnemies ||
        spawnedAsteroids == totalAsteroids) {
      _enemySpawner.timer.pause();
      removeSpawnedComponents();
      if(userId!=null){
        if(highestScore<score){
          highestScore=score;
        }
        if(highestLevel<level){
          highestLevel=level;
        }
        updateUserInfo(userId);
      }
      overlays.remove("HUD");
      totalAsteroids = 1000;
      spawnedAsteroids = 0;
      if (!overlays.isActive("GameOverMenu")) {
        // Only go to next level if game is not over;
        // this prevents multiple overlays simultaneously
        overlays.add("NextLevelMenu");
      }


    }
  }

  void removeSpawnedComponents() {
    // Helper function to prepare for displaying overlays
    var childrenCopy = List.from(children);
    for (var child in childrenCopy) {
      if (child is Enemy ||
          child is Bullet ||
          child is SpawnComponent ||
          child is Collectable ||
          child is Asteroid ||
          child is PowerUpCollectable) {
        remove(child);
      }
    }
  }

  void reset() async {
    for (var child in children) {
      remove(child);
    }
    gameStarted = true;
    totalEnemies = random.nextInt(4) + 4;
    parallaxImages = ["stars0.png", "stars1.png", "stars2.png"];
    noEnemies = 0;
    enemiesSpawned = 0;
    enemiesDestroyed = 0;
    score = highestScore;
    level = highestLevel;
    playerHealth = 100;
    parallax = await loadParallaxComponent(
      [
        ParallaxImageData(parallaxImages[0]),
        ParallaxImageData(parallaxImages[1]),
        ParallaxImageData(parallaxImages[2]),
      ],
      baseVelocity: Vector2(0, -1),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 4),
    );

    add(parallax);
    player = Player();
    add(player);
    add(_enemySpawner);
    add(_collectableSpawner);

    if (healPowerUp) {
      add(_healPowerUpSpawner);
    }
    if (machineGunPowerUp) {
      add(_machineGunPowerUpSpawner);
    }

    overlays.add("HUD");
  }

  void generateNextLevel() async {
    level += 1;
    totalEnemies = level * random.nextInt(4) + 4;
    parallaxImages = ["stars0.png", "stars1.png", "stars2.png"];

    for (var child in children) {
      remove(child);
    }
    noEnemies = 0;
    enemiesSpawned = 0;
    enemiesDestroyed = 0;
    parallax = await loadParallaxComponent(
      [
        ParallaxImageData(parallaxImages[0]),
        ParallaxImageData(parallaxImages[1]),
        ParallaxImageData(parallaxImages[2]),
      ],
      baseVelocity: Vector2(0, -1),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 4),
    );
    add(parallax);
    player = Player();
    add(player);
    add(_enemySpawner);
    add(_collectableSpawner);

    if (healPowerUp) {
      add(_healPowerUpSpawner);
    }
    if (machineGunPowerUp) {
      add(_machineGunPowerUpSpawner);
    }

    overlays.add("HUD");
  }

  void generateAsteroidLevel() async {
    level += 1;
    parallaxImages = ["stars0.png", "stars1.png", "stars2.png"];

    totalAsteroids = random.nextInt(24) + 10 + level;
    spawnedAsteroids = 0;

    for (var child in children) {
      remove(child);
    }
    noEnemies = 0;
    enemiesSpawned = 0;
    enemiesDestroyed = 0;
    parallax = await loadParallaxComponent(
      [
        ParallaxImageData(parallaxImages[0]),
        ParallaxImageData(parallaxImages[1]),
        ParallaxImageData(parallaxImages[2]),
      ],
      baseVelocity: Vector2(0, -1),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 4),
    );
    add(parallax);
    player = Player();
    add(player);
    add(_collectableSpawner);
    add(_asteroidSpawner);

    if (healPowerUp) {
      add(_healPowerUpSpawner);
    }
    if (machineGunPowerUp) {
      add(_machineGunPowerUpSpawner);
    }

    overlays.add("HUD");
  }

  Color getHealthColour() {
    // Return green when shields are 90%-100%
    // Return yellow when shields are 50%-90%
    // Return orange when shields are 25%-50%
    // Return red when shields are 0%-25%
    if (playerHealth >= 90) {
      return const Color.fromARGB(255, 34, 255, 0);
    } else if (playerHealth >= 50) {
      return const Color.fromARGB(255, 255, 251, 1);
    } else if (playerHealth >= 25) {
      return const Color.fromARGB(255, 255, 149, 0);
    } else {
      return const Color.fromARGB(255, 255, 0, 0);
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }

  Future<void> fetchUserData(String Id) async {
    try {
      if (Id != null) {
        userId = Id;
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(Id).get();

        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        creditsCollected = userData['creditsCollected'];
        shieldCapacityIPowerUp = userData['shieldCapacityIPowerUp'];
        shieldCapacityIIPowerUp = userData['shieldCapacityIIPowerUp'];
        shieldCapacityIIIPowerUp = userData['shieldCapacityIIIPowerUp'];
        shieldCapacityIVPowerUp = userData['shieldCapacityIVPowerUp'];
        shieldCapacityVPowerUp = userData['shieldCapacityVPowerUp'];
        shieldCapacityVIPowerUp = userData['shieldCapacityVIPowerUp'];
        fireRateIPowerUp = userData['fireRateIPowerUp'];
        fireRateIIPowerUp = userData['fireRateIIPowerUp'];
        healPowerUp = userData['healPowerUp'];
        machineGunPowerUp = userData['machineGunPowerUp'];
        highestScore = userData['highestScore'];
        highestLevel = userData['highestLevel'];
        unlockedItems = List<String>.from(userData['unlockedItems']); // Fetching unlockedItems
        level=highestLevel;
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  void updateUserInfo(String userId) async {
    try {
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'creditsCollected': creditsCollected,
          'shieldCapacityIPowerUp': shieldCapacityIPowerUp,
          'shieldCapacityIIPowerUp': shieldCapacityIIPowerUp,
          'shieldCapacityIIIPowerUp': shieldCapacityIIIPowerUp,
          'shieldCapacityIVPowerUp': shieldCapacityIVPowerUp,
          'shieldCapacityVPowerUp': shieldCapacityVPowerUp,
          'shieldCapacityVIPowerUp': shieldCapacityVIPowerUp,
          'fireRateIPowerUp': fireRateIPowerUp,
          'fireRateIIPowerUp': fireRateIIPowerUp,
          'healPowerUp': healPowerUp,
          'machineGunPowerUp': machineGunPowerUp,
          'highestScore': highestScore,
          'highestLevel': highestLevel,
          'unlockedItems': unlockedItems, // Updating unlockedItems
        });
      }
    } catch (e) {
      // print(e.toString());
    }
  }
}






