import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Domain/entities/AdminSignInResponse.dart';
import 'package:project_cleanarchiteture/Features/auth/Logout/Presentation/bloc/logout_bloc.dart';
import 'package:project_cleanarchiteture/Utils/Extensions.dart';
import 'package:project_cleanarchiteture/Utils/Routing.dart';
import 'package:project_cleanarchiteture/Utils/localData.dart';
import 'package:project_cleanarchiteture/Widgets/CutomButton.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> with LocalData {
  late String newDeviceId;

  @override
  void initState() {
    getToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutFailureState) {
          print('on screen: submission failure');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.replaceAll('Exception:', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is LogoutSuccessState) {
          print('on screen: success');

          context.pushReplacement(SIGNIN);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logged out"),
            ),
          );
        }
      },
      builder: (context, state) {
        return _LogoutButton();
      },
    );
  }

  Widget _LogoutButton() {
    return BlocBuilder<LogoutBloc, LogoutState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomButton(
            color: Colors.blue,
            title: state is LogoutLoadingState
                ? const Center(child: CircularProgressIndicator())
                : const Text(
                    'Logout',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            onClick: () async {
              GoogleSignIn? _googleUser;
              AccessToken? _facebookAccessToken;

              _googleUser = GoogleSignIn(scopes: ['email']);
              // GoogleSignIn().currentUser;
              _facebookAccessToken = await FacebookAuth.instance.accessToken;

              print("google user: ${_googleUser.isSignedIn()}");
              print("fb user: $_facebookAccessToken");

              if (_facebookAccessToken != null) {
                facebookLogOut();
              } else if (await _googleUser.isSignedIn()) {
                handleGoogleSignOut();
              } else {
                await getUserinfo(USER_INFO);

                String? userDataJson = savedLoginData;

                print(jsonDecode(userDataJson!));

                print(LoginAdmin.fromJson(jsonDecode(userDataJson)));

                LoginAdmin userData =
                    LoginAdmin.fromJson(jsonDecode(userDataJson));

                String deviceId = newDeviceId;
                String token = userData.token;

                print("device id: $deviceId");
                print("token: $token");

                state is! LogoutLoadingState
                    ? context.read<LogoutBloc>().add(
                          LogoutButtonPressed(
                            deviceId: deviceId,
                            token: token,
                          ),
                        )
                    : null;
              }
            },
          ),
        );
      },
    );
  }

  Future<String> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        newDeviceId = token!;
        print("Token deviceId: $newDeviceId");
      });
    });
    return newDeviceId;
  }

  Future<void> facebookLogOut() async {
    try {
      await FacebookAuth.instance.logOut();

      clearSharedPreferences();

      context.pushReplacement(SIGNIN);
    } catch (error) {
      print("Sign in error: ${error.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Facebook Logout Failed!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> handleGoogleSignOut() async {
    try {
      await _googleSignIn.disconnect();

      clearSharedPreferences();

      context.pushReplacement(SIGNIN);
    } catch (error) {
      print("Signout error: ${error.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Logout Failed! $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
