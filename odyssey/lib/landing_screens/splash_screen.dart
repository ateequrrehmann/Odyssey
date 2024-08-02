import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../odyssey_game.dart';

class SplashScreen extends StatefulWidget {
  final OdysseyGame game;
  const SplashScreen({Key? key, required this.game}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _imageAnimation;
  late List<Animation<double>> _letterAnimations;
  var isLogin = false;
  var auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _initLetterAnimations();
    _controller.forward(); // Start the animation
    checkIfLogin();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initLetterAnimations() {
    _letterAnimations = List.generate(
      7,
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (index / 7) * 0.5,
            ((index + 1) / 7) * 0.5,
            curve: Curves.easeIn,
          ),
        ),
      ),
    );
  }

  Future<void> checkIfLogin() async {
    auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        setState(() {
          isLogin = true;
        });
        await widget.game.fetchUserData(user.uid);
        navigateToMainMenu();
      } else {
        _startSplashScreenTimer();
      }
    });
  }

  Future<void> _startSplashScreenTimer() async {
    await Future.delayed(const Duration(milliseconds: 4000));
    if (!isLogin && mounted) {
      navigateToSignIn();
    }
  }

  void navigateToMainMenu() {
    if (mounted) {
      widget.game.overlays.remove('SplashScreen');
      widget.game.overlays.add('MainMenu');
    }
  }

  void navigateToSignIn() {
    if (mounted) {
      widget.game.overlays.remove('SplashScreen');
      widget.game.overlays.add('SignIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/stars2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _imageAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image.asset('assets/images/splashicon.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildAnimatedText('Odyssey'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText(String text) {
    List<Widget> animatedText = [];
    for (int i = 0; i < text.length; i++) {
      animatedText.add(
        FadeTransition(
          opacity: _letterAnimations[i],
          child: Text(
            text[i],
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: animatedText,
    );
  }
}
