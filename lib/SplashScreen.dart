import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:project_cleanarchiteture/Utils/Extensions.dart';
import 'package:project_cleanarchiteture/Utils/Routing.dart';
import 'package:project_cleanarchiteture/Widgets/CutomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  var savedLoginData;

  Future<void> _getSavedLoginData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final loginData = prefs.getString(USER_INFO);
    setState(() {
      savedLoginData = loginData;
    });

    print("loginData: $loginData");
    print("savedLoginData: $savedLoginData");
    // print("savedLoginData: ${json.decode(savedLoginData)}");
  }

  late GoogleSignInAccount currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();

    _getSavedLoginData();

    loadDataAndNavigate();

    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        currentUser = account!;
      });

      if (currentUser != null) {
        print("User already authenticated");
        context.pushReplacement(USER);
      }
    });

    _googleSignIn.signInSilently();
  }

  Future<void> loadDataAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    // GoogleSignInAccount user = LoginFrom.currentUser;
    // if (user != null) {
    //   context.go(USER);
    // }

    var user;

    if (savedLoginData != null) {
      context.go(USER);
    } else {
      context.go(SIGNIN);
    }

    // ignore: use_build_context_synchronously
    // context.go(SIGNIN);

    // context.go(USER);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Expanded(
              child: Lottie.asset(
                'assets/animationSplash.json',
                height: 200,
                width: 200,
              ),
            ),
            CustomButton(
              color: Colors.blue,
              title: const Text(
                'Skip',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onClick: () {
                print("Skipped");
                if (savedLoginData != null) {
                  context.go(USER);
                } else {
                  context.go(SIGNIN);
                }
              },
            ),

            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size.fromHeight(50),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   onPressed: () {
            //     if (savedLoginData != null) {
            //       context.go(USER);
            //     } else {
            //       context.go(SIGNIN);
            //     }
            //     // loadDataAndNavigate();
            //   },
            //   child: const Text("Skip"),
            // ),
          ],
        ),
      ),
    );
  }
}
