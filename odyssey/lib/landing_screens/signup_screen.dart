import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odyssey/game_ui_button.dart';
import 'package:odyssey/reusable_widgets/reusable_widgets.dart';
import 'package:odyssey/odyssey_game.dart';


class SignUpScreen extends StatefulWidget {
  final OdysseyGame game;
  const SignUpScreen({super.key, required this.game});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  bool _isPasswordVisible = false;
  bool shieldCapacityIPowerUp=false;
  bool shieldCapacityIIPowerUp=false;
  bool shieldCapacityIIIPowerUp=false;
  bool shieldCapacityIVPowerUp=false;
  bool shieldCapacityVPowerUp=false;
  bool shieldCapacityVIPowerUp=false;
  bool fireRateIPowerUp=false;
  bool fireRateIIPowerUp=false;
  bool healPowerUp=false;
  bool machineGunPowerUp=false;
  int highestScore=0;
  int highestLevel=1;
  int creditsCollected=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/stars2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter UserName", Icons.person_outline, false,
                  _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Email Id", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passwordTextController,
                obscureText: !_isPasswordVisible,  // Update based on visibility
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.white70,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;  // Toggle visibility
                      });
                    },
                    child: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,  // Change icon based on visibility
                      color: Colors.white70,
                    ),
                  ),
                  labelText: "Enter Password",
                  labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 0, style: BorderStyle.none)
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 20,
              ),
              SignUpHandler(
                nameController: _userNameTextController,
                emailController: _emailTextController,
                passwordController: _passwordTextController,
                game: widget.game,
                highestScore: highestScore,
                healPowerUp: healPowerUp,
                fireRateIPowerUp: fireRateIPowerUp,
                creditsCollected: creditsCollected,
                highestLevel: highestLevel,
                machineGunPowerUp: machineGunPowerUp,
                shieldCapacityIPowerUp: shieldCapacityIPowerUp,
                fireRateIIPowerUp: fireRateIIPowerUp,
                shieldCapacityIIIPowerUp: shieldCapacityIIIPowerUp,
                shieldCapacityIIPowerUp: shieldCapacityIIPowerUp,
                shieldCapacityIVPowerUp: shieldCapacityIVPowerUp,
                shieldCapacityVIPowerUp: shieldCapacityVIPowerUp,
                shieldCapacityVPowerUp: shieldCapacityVPowerUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpHandler extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final OdysseyGame game;
  final bool shieldCapacityIPowerUp;
  final bool shieldCapacityIIPowerUp;
  final bool shieldCapacityIIIPowerUp;
  final bool shieldCapacityIVPowerUp;
  final bool shieldCapacityVPowerUp;
  final bool shieldCapacityVIPowerUp;
  final bool fireRateIPowerUp;
  final bool fireRateIIPowerUp;
  final bool healPowerUp;
  final bool machineGunPowerUp;
  final int highestScore;
  final int highestLevel;
  final int creditsCollected;

  const SignUpHandler({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.game,
    required this.highestScore,
    required this.healPowerUp,
    required this.fireRateIPowerUp,
    required this.creditsCollected,
    required this.highestLevel,
    required this.machineGunPowerUp,
    required this.shieldCapacityIPowerUp,
    required this.fireRateIIPowerUp,
    required this.shieldCapacityIIIPowerUp,
    required this.shieldCapacityIIPowerUp,
    required this.shieldCapacityIVPowerUp,
    required this.shieldCapacityVIPowerUp,
    required this.shieldCapacityVPowerUp,
  });

  @override
  Widget build(BuildContext context) {
    return GameUIButton(
      buttonLabel: "Sign Up",
      labelFontSize: 20,
      callback: () async {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text);

          String userId = userCredential.user!.uid;

          await FirebaseFirestore.instance.collection('users').doc(userId).set({
            'username': nameController.text,
            'email': emailController.text,
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
            'unlockedItems': [],
          });


          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Congratulations'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("User Created Successfully"),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      game.fetchUserData(userId);
                      game.overlays.remove("SignUp");
                      game.overlays.add("MainMenu");
                    },
                  ),
                ],
              );
            },
          );
        } catch (error) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Wrong Credentials'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Error ${error.toString()}"),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      width: MediaQuery.of(context).size.width,
      height: 50,
    );
  }
}

