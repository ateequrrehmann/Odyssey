import "dart:math";
import "package:flutter/material.dart";

import "odyssey_game.dart";
import "game_ui_button.dart";
import "ui_constants.dart";

class UnlockedPopUp extends StatelessWidget {
  final OdysseyGame game;
  final Random random = Random();

  UnlockedPopUp({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: UIConstants.blackTextColor,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "unlocked!",
                style: TextStyle(
                  color: UIConstants.whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              GameUIButton(
                buttonLabel: "ok",
                labelFontSize: UIConstants.menuButtonTextFontSize,
                callback: () {
                  game.overlays.remove("UnlockedPopUp");
                  game.overlays.add("ShopMenu");
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