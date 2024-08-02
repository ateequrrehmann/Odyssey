import 'dart:io';
import 'package:flutter/material.dart';

import 'odyssey_game.dart';
import 'game_ui_button.dart';
import 'ui_constants.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({super.key, required this.game});

  final OdysseyGame game;

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit Game"),
          content: const Text("Are you sure you want to exit?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                exit(0); // Exit the app
              },
            ),
          ],
        );
      },
    );
  }

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
                "paused",
                style: TextStyle(
                  color: UIConstants.whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              GameUIButton(
                buttonLabel: "Resume",
                labelFontSize: UIConstants.menuButtonTextFontSize,
                callback: () {
                  game.overlays.remove("PauseMenu");
                  game.resumeEngine();
                },
                width: UIConstants.menuButtonWidth,
                height: UIConstants.menuButtonHeight,
              ),
              const SizedBox(height: 40),
              GameUIButton(
                buttonLabel: "Exit",
                labelFontSize: UIConstants.menuButtonTextFontSize,
                callback: () => _showExitConfirmationDialog(context),
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
