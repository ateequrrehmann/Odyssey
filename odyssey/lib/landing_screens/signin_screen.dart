import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odyssey/game_ui_button.dart';
import 'package:odyssey/odyssey_game.dart';
import 'package:odyssey/reusable_widgets/reusable_widgets.dart';


class SignInScreen extends StatefulWidget {
  final OdysseyGame game;
  const SignInScreen({Key? key, required this.game}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/splashicon.png',
                  fit: BoxFit.fitWidth,
                  width: 240,
                  height: 240,
                ),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                    "Enter Email", Icons.person_outline, false, _emailTextController),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _passwordTextController,
                  obscureText: !_isPasswordVisible,
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
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                SignInHandler(
                  emailController: _emailTextController,
                  passwordController: _passwordTextController,
                  game: widget.game,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          widget.game.overlays.remove("SignIn");
                          widget.game.overlays.add("SignUp");
                        },
                        child: const Text(
                          " Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forget Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: (){
          widget.game.overlays.remove("SignIn");
          widget.game.overlays.add("Reset");
        }
      ),
    );
  }
}

class SignInHandler extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OdysseyGame game;

  const SignInHandler({
    required this.emailController,
    required this.passwordController,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return GameUIButton(
      buttonLabel: "Sign In",
      labelFontSize: 16,
      callback: () async {
        String? userId;
        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          userId = userCredential.user!.uid; // Store the userId
          await game.fetchUserData(userId); // Pass userId to fetchUserData
          game.overlays.remove("SignIn");
          game.overlays.add("MainMenu");
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

