import "package:flutter/material.dart";

import "odyssey_game.dart";
import "game_ui_button.dart";
import "ui_constants.dart";

class GameOverMenu extends StatelessWidget {
  const GameOverMenu({super.key, required this.game});

  final OdysseyGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: game.size.y,
          width: game.size.x,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "game over",
                style: TextStyle(
                  color: UIConstants.whiteTextColor,
                  fontSize: UIConstants.menuButtonTextFontSize,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "score: ${game.score}",
                style: const TextStyle(
                  color: UIConstants.whiteTextColor,
                  fontSize: UIConstants.menuButtonTextFontSize,
                ),
              ),
              const SizedBox(height: 40),
              GameUIButton(
                buttonLabel: "Play Again",
                labelFontSize: UIConstants.menuButtonTextFontSize,
                callback: () {
                  game.overlays.remove("GameOverMenu");
                  game.reset();
                },
                width: UIConstants.menuButtonWidth,
                height: UIConstants.menuButtonHeight,
              ),
              const SizedBox(height: 40),
              GameUIButton(
                buttonLabel: "main menu",
                labelFontSize: UIConstants.menuButtonTextFontSize,
                callback: () {
                  game.overlays.remove("GameOverMenu");
                  game.overlays.add("MainMenu");
                },
                width: UIConstants.menuButtonWidth,
                height: UIConstants.menuButtonHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}