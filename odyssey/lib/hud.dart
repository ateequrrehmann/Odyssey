import "package:flutter/material.dart";

import "odyssey_game.dart";
import "game_ui_button.dart";
import "ui_constants.dart";

class HUD extends StatefulWidget {
  const HUD({super.key, required this.game, required this.healthColour});

  final OdysseyGame game;
  final Color healthColour;

  @override
  State<HUD> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<HUD> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 250,
        width: 250,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                height: 250,
                width: 120,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GameUIButton(
                      buttonLabel: "pause",
                      labelFontSize: 16.0,
                      callback: () {
                        widget.game.pauseEngine();
                        widget.game.overlays.add("PauseMenu");
                      },
                      width: 100,
                      height: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "score: ${widget.game.score}",
                      style: const TextStyle(
                        color: UIConstants.whiteTextColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "level: ${widget.game.level}",
                      style: const TextStyle(
                        color: UIConstants.whiteTextColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$ ${widget.game.creditsCollected}",
                      style: const TextStyle(
                        color: UIConstants.whiteTextColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "shields: ${widget.game.playerHealth}%",
                      style: TextStyle(
                        color: widget.healthColour,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
