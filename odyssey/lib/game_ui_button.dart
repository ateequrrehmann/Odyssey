import 'package:flutter/material.dart';

class GameUIButton extends StatefulWidget {
  const GameUIButton(
      {super.key,
        required this.buttonLabel,
        required this.labelFontSize,
        required this.callback,
        required this.width,
        required this.height});

  final String buttonLabel;
  final double labelFontSize;
  final VoidCallback callback;
  final double width;
  final double height;

  @override
  State<GameUIButton> createState() => _GameUIButtonState();
}

class _GameUIButtonState extends State<GameUIButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
          onPressed: widget.callback,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.white70, width: 2.0),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: widget.width,
                maxHeight: widget.height,
              ),
              alignment: Alignment.center,
              child: Text(
                widget.buttonLabel,
                style: TextStyle(
                  fontSize: widget.labelFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
