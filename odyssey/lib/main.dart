import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:odyssey/landing_screens/signin_screen.dart';
import 'package:odyssey/landing_screens/signup_screen.dart';
import 'package:odyssey/landing_screens/splash_screen.dart';

import 'firebase_options.dart';
import 'landing_screens/reset_password.dart';
import 'odyssey_game.dart';
import 'main_menu.dart';
import 'game_over_menu.dart';
import 'next_level_menu.dart';
import 'hud.dart';
import 'pause_menu.dart';
import 'shop_menu.dart';
import 'already_unlocked_popup.dart';
import 'not_enough_credits_popup.dart';
import 'unlocked_popup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameWidget<OdysseyGame>.controlled(
        gameFactory: () => OdysseyGame(),
        overlayBuilderMap: {
          "SplashScreen": (_, game) {
            game.gameStarted=false;
            game.removeSpawnedComponents();
            return SplashScreen(game: game);
          } ,
          "Reset": (_, game) {
            game.gameStarted=false;
            game.removeSpawnedComponents();
            return ResetPassword(game: game);
          } ,
          "SignIn": (_, game) {
            game.gameStarted=false;
            game.removeSpawnedComponents();
            return SignInScreen(game: game);
          } ,
          "SignUp": (_, game) {
            game.gameStarted=false;
            game.removeSpawnedComponents();
            return SignUpScreen(game: game);
          } ,
          "MainMenu": (_, game) {
            game.gameStarted = false;
            game.removeSpawnedComponents();
            return MainMenu(game: game);
          },
          "GameOverMenu": (_, game) {
            game.gameStarted = false;
            game.removeSpawnedComponents();
            return GameOverMenu(game: game);
          },
          "NextLevelMenu": (_, game) => NextLevelMenu(game: game),
          "HUD": (_, game) {
            Color healthColour = game.getHealthColour();
            return HUD(game: game, healthColour: healthColour);
          },
          "PauseMenu": (_, game) => PauseMenu(game: game),
          "ShopMenu": (_, game) => ShopMenu(game: game),
          "NotEnoughCreditsPopUp": (_, game) => NotEnoughCreditsPopUp(game: game),
          "AlreadyUnlockedPopUp": (_, game) => AlreadyUnlockedPopUp(game: game),
          "UnlockedPopUp": (_, game) => UnlockedPopUp(game: game),
        },
        initialActiveOverlays: const ["SplashScreen"],
      ),
    );
  }
}