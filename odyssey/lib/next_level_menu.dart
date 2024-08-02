import "dart:math";
import "package:flutter/material.dart";

import "odyssey_game.dart";
import "ui_constants.dart";

class NextLevelMenu extends StatelessWidget {
  final OdysseyGame game;
  final Random random = Random();

  NextLevelMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // Schedule the next level generation after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      game.overlays.remove("NextLevelMenu");
      // 1 in 10 chance level will be an asteroid level
      if (random.nextInt(10) == 1) {
        game.generateAsteroidLevel();
      } else {
        game.generateNextLevel();
      }
    });

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: game.size.y,
          width: game.size.x,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "level complete",
                style: TextStyle(
                  color: UIConstants.whiteTextColor,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Loading next level...",
                style: TextStyle(
                  color: UIConstants.whiteTextColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
