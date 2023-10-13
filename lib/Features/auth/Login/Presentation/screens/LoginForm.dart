import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Domain/entities/AdminSignInResponse.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Domain/params/UserLoginInput.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Presentation/bloc/login_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:project_cleanarchiteture/Utils/Routing.dart';
import 'package:project_cleanarchiteture/Utils/localData.dart';
import 'package:project_cleanarchiteture/Widgets/CutomButton.dart';

// class LoginFromWidget extends StatelessWidget {
//   const LoginFromWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => LoginBloc(
//           loginRepo: LoginRepositoryImple(
//               remotedatasources: LoginRemoteDatasourceImpl())),
//       child: LoginFrom(
//         loginBloc: LoginBloc(
//             loginRepo: LoginRepositoryImple(
//                 remotedatasources: LoginRemoteDatasourceImpl())),
//       ),
//     );
//   }
// }

class LoginFrom extends StatefulWidget {
  LoginFrom({super.key, required this.loginBloc});

  final LoginBloc loginBloc;

  late GoogleSignInAccount currentUser;

  @override
  State<LoginFrom> createState() => _LoginFromState();
}

class _LoginFromState extends State<LoginFrom> with LocalData {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginBloc get _loginBloc => widget.loginBloc;

  bool isObscure = true;
  final _key = GlobalKey<FormState>();

  String newtoken = "";
  var ipAddress;

  Future<String> fetchPublicIP() async {
    final response =
        await http.get(Uri.parse('https://api.ipify.org?format=json'));

    if (response.statusCode == 200) {
      final address = jsonDecode(response.body)['ip'];
      ipAddress = address;
      print("IP Address: $ipAddress");

      return ipAddress;
    } else {
      print("Failed to fetch public IP");
      throw Exception('Failed to fetch public IP');
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<String> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        newtoken = token!;
        print("Token: $newtoken");
      });
    });
    return newtoken;
  }

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        widget.currentUser = account!;
      });

      if (widget.currentUser != null) {
        print("User already authenticated");
        context.pushReplacement(USER);
      }
    });

    _googleSignIn.signInSilently();

    requestPermission();
    getToken();
    fetchPublicIP();
  }

  Future<void> handleSignIn() async {
    try {
      GoogleSignInAccount? user = await _googleSignIn.signIn();

      print("User : ${user!}");

      if (user != null) {
        Map<String, dynamic> googleSignInData = {
          'displayName': user.displayName,
          'email': user.email,
          'id': user.id,
          'photoUrl': user.photoUrl,
          'serverAuthCode': user.serverAuthCode,
        };

        setUserinfo(
          jsonEncode(googleSignInData),
        );
      }

      context.pushReplacement(USER);
    } catch (error) {
      print("Sign in error: ${error.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login wth google failed! ${error.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailureState) {
          print('on screen: submission failure');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.replaceAll('Exception:', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is LoginSuccessState) {
          print('on screen: success');

          // context.pushReplacement(HOME);
          context.pushReplacement(USER);

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const HomeScreen(),
          //   ),
          // );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logged in"),
            ),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _key,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
              ),
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset((deviceWidth * 0.4), -(deviceHeight * 0.30)),
                    child: const CircleAvatar(
                      radius: 300,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(height: (deviceHeight - 550)),
                      const Text(
                        "Welcome,",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                        ),
                      ),
                      const Text(
                        "Sign in to continue!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null) return "Enter Email";
                          if (value.isEmpty ||
                              !RegExp(
                                r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
                              ).hasMatch(value)) {
                            return "Enter Email correctly";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (text) {},
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty
                              // ||
                              //     !RegExp(
                              //       r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
                              //     ).hasMatch(value)
                              ) {
                            return "Enter Password correctly";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (text) {},
                        obscureText: isObscure,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(1, 0),
                        child: TextButton(
                          onPressed: () {
                            context.push(FORGET_PASSWORD);

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return ForgetPasswordView();
                            //     },
                            //   ),
                            // );
                          },
                          child: const Text("Forget Password?"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: _LoginButton(
                          input: UserLoginInput(
                            email: emailController.text,
                            password: passwordController.text,
                            deviceId: newtoken,
                            loginIp: ipAddress,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                Map<String, dynamic>? _userData;
                                AccessToken? _accessToken;
                                bool _checking = true;

                                final LoginResult result = await FacebookAuth
                                    .instance
                                    .login(permissions: [
                                  "public_profile",
                                  "email"
                                ]).then((value) {
                                  FacebookAuth.instance
                                      .getUserData()
                                      .then((userData) async {
                                    print("User data from fb: $userData");
                                  });
                                  return value;
                                }); // by default we request the email and the public profile

                                // loginBehavior is only supported for Android devices, for ios it will be ignored
                                // final result = await FacebookAuth.instance.login(
                                //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
                                //   loginBehavior: LoginBehavior
                                //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
                                // );

                                if (result.status == LoginStatus.success) {
                                  _accessToken = result.accessToken;

                                  // get the user data
                                  // by default we get the userId, email,name and picture
                                  final userData =
                                      await FacebookAuth.instance.getUserData();
                                  // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
                                  _userData = userData;

                                  setUserinfo(jsonEncode(_userData));

                                  context.go(USER);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Login wth Facebook failed!"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );

                                  print(result.status);
                                  print(result.message);
                                }

                                setState(() {
                                  _checking = false;
                                });
                              },
                              icon: const Icon(
                                Icons.facebook,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              onPressed: handleSignIn,
                              icon: const Text(
                                "G",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't Have an Account?"),
                          TextButton(
                            onPressed: () {
                              context.push(SIGNUP);

                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return SignUpView();
                              //     },
                              //   ),
                              // );
                            },
                            child: const Text("Sign Up"),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final loginBloc = BlocProvider.of<LoginBloc>(context);
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Login'),
  //     ),
  //     body: BlocListener<LoginBloc, LoginState>(
  //       listener: (context, state) {
  //         if (state is LoginSuccessState) {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const HomeScreen(),
  //             ),
  //           );
  //         } else if (state is LoginFailureState) {
  //           // Handle login failure, show an error message, etc.
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(state.error),
  //               duration: Duration(seconds: 3),
  //             ),
  //           );
  //         }
  //       },
  //       child: BlocBuilder<LoginBloc, LoginState>(
  //         builder: (context, state) {
  //           return Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 TextField(
  //                   controller: emailController,
  //                   decoration: InputDecoration(labelText: 'Email'),
  //                 ),
  //                 TextField(
  //                   controller: passwordController,
  //                   obscureText: true,
  //                   decoration: InputDecoration(labelText: 'Password'),
  //                 ),
  //                 SizedBox(height: 20),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     final input = UserLoginInput(
  //                       email: emailController.text,
  //                       password: passwordController.text,
  //                       deviceId: newtoken,
  //                       loginIp: ipAddress,
  //                     );
  //                     loginBloc.add(LoginButtonPressed(input: input));
  //                   },
  //                   child: Text('Login'),
  //                 ),
  //                 if (state is LoginLoadingState) CircularProgressIndicator(),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return BlocBuilder<LoginBloc, LoginState>(
  //     bloc: _loginBloc,
  //     builder: (context, state) {
  //       if (state is LoginInitialState) {
  //         return Form(
  //           key: _key,
  //           child: SingleChildScrollView(
  //             child: Padding(
  //               padding: const EdgeInsets.all(12.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 // ignore: prefer_const_literals_to_create_immutables
  //                 children: [
  //                   Stack(
  //                     children: [
  //                       Image.asset(
  //                         'assets/paper.png',
  //                         width: 210,
  //                         height: 210,
  //                       ),
  //                       Positioned(
  //                         top: 32,
  //                         left: 67,
  //                         child: AnimatedContainer(
  //                           duration: const Duration(milliseconds: 300),
  //                           curve: Curves.bounceOut,
  //                           height: initailHeight,
  //                           child: isObscure
  //                               ? const SizedBox()
  //                               : Image.asset(
  //                                   'assets/shhhh.png',
  //                                   width: 80,
  //                                   height: 80,
  //                                 ),
  //                         ),
  //                       ),
  //                       Positioned(
  //                         bottom: 2,
  //                         right: 48,
  //                         child: AnimatedContainer(
  //                           duration: const Duration(milliseconds: 300),
  //                           transform: Matrix4.translationValues(_offset, 0, 0),
  //                           child: Image.asset(
  //                             'assets/pencil.png',
  //                             width: 100,
  //                             height: 100,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   // Image.asset(
  //                   //   "assets/login.png",
  //                   //   width: 200,
  //                   //   height: 200,
  //                   // ),
  //                   const Text(
  //                     "Sign In",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 68,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 30),
  //                   TextFormField(
  //                     keyboardType: TextInputType.emailAddress,
  //                     validator: (value) {
  //                       if (value == null) return "Enter Email";
  //                       if (value.isEmpty ||
  //                           !RegExp(
  //                             r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  //                           ).hasMatch(value)) {
  //                         return "Enter Email correctly";
  //                       } else {
  //                         return null;
  //                       }
  //                     },
  //                     onChanged: (text) {
  //                       if (text.isNotEmpty) {
  //                         _startAnimationPencil();
  //                       } else {
  //                         _stopAnimationPencil();
  //                       }
  //                     },
  //                     controller: emailController,
  //                     decoration: const InputDecoration(
  //                       labelText: 'Email',
  //                     ),
  //                   ),
  //                   TextFormField(
  //                     validator: (value) {
  //                       if (value!.isEmpty ||
  //                           !RegExp(
  //                             r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  //                           ).hasMatch(value)) {
  //                         return "Enter Password correctly";
  //                       } else {
  //                         return null;
  //                       }
  //                     },
  //                     onChanged: (text) {
  //                       if (text.isNotEmpty) {
  //                         _startAnimationPencil();
  //                       } else {
  //                         _stopAnimationPencil();
  //                       }
  //                     },
  //                     obscureText: isObscure,
  //                     controller: passwordController,
  //                     decoration: InputDecoration(
  //                       labelText: 'Password',
  //                       suffixIcon: IconButton(
  //                         icon: Icon(
  //                           isObscure ? Icons.visibility : Icons.visibility_off,
  //                         ),
  //                         onPressed: () {
  //                           setState(() {
  //                             isObscure = !isObscure;
  //                             if (!isObscure) {
  //                               _startAnimationShhh();
  //                             } else {
  //                               _stopAnimationShhh();
  //                             }
  //                             // sizeChange();
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),

  //                   ElevatedButton(
  //                     onPressed: () {
  //                       state is! LoginLoadingState ? submitButton() : null;
  //                       // state is! LoginLoadingState
  //                       //     ?
  //                       // context.read<LoginBloc>().add(
  //                       //       LoginButtonPressed(
  //                       //         input: UserLoginInput(
  //                       //           email: emailController.text,
  //                       //           password: passwordController.text,
  //                       //           deviceId: newtoken,
  //                       //           loginIp: ipAddress,
  //                       //         ),
  //                       //       ),
  //                       //     );
  //                       // : null;
  //                       // print("State: $state");

  //                       // state is LoginLoadingState
  //                       //     ? const CircularProgressIndicator()
  //                       //     : null;
  //                       // state is LoginSuccessState
  //                       //     ? Navigator.push(
  //                       //         context,
  //                       //         MaterialPageRoute(
  //                       //           builder: (context) => const HomeScreen(),
  //                       //         ),
  //                       //       )
  //                       //     : null;
  //                       // print("State 2: $state");

  //                       // state is LoginFailureState
  //                       //     ? ScaffoldMessenger.of(context).showSnackBar(
  //                       //         const SnackBar(
  //                       //           content: Text("error"),
  //                       //           // backgroundColor: Colors.red,
  //                       //         ),
  //                       //       )
  //                       //     : null;

  //                       // if (state is! LoginLoadingState) {
  //                       // context.read<LoginBloc>().add(
  //                       //       LoginButtonPressed(
  //                       //         input: UserLoginInput(
  //                       //           email: emailController.text,
  //                       //           password: passwordController.text,
  //                       //           deviceId: newtoken,
  //                       //           loginIp: ipAddress,
  //                       //         ),
  //                       //       ),
  //                       //     );
  //                       // print("state1: $state");
  //                       // }
  //                       // if (state is LoginSuccessState) {
  //                       //   print("state2: $state");

  //                       //   Navigator.push(
  //                       //     context,
  //                       //     MaterialPageRoute(
  //                       //       builder: (context) => const HomeScreen(),
  //                       //     ),
  //                       //   );
  //                       // } else if (state is LoginFailureState) {
  //                       //   print("state3: $state");
  //                       //   ScaffoldMessenger.of(context).showSnackBar(
  //                       //     const SnackBar(
  //                       //       content: Text("error"),
  //                       //       // backgroundColor: Colors.red,
  //                       //     ),
  //                       //   );
  //                       // }

  //                       // print(state);
  //                       // ScaffoldMessenger.of(context).showSnackBar(
  //                       //   const SnackBar(
  //                       //     content: Text("logged in"
  //                       //         // state.message,
  //                       //         ),
  //                       //     // backgroundColor: Colors.red,
  //                       //   ),
  //                       // );

  //                       // Navigator.push(
  //                       //   context,
  //                       //   MaterialPageRoute(
  //                       //     builder: (context) => const HomeScreen(),
  //                       //   ),
  //                       // );
  //                     },
  //                     child:
  //                         //  state is LoginLoadingState
  //                         //     ? const CircularProgressIndicator()
  //                         //     :
  //                         const Text("Login"),
  //                   ),
  //                   const SizedBox(height: 20),

  //                   TextButton(
  //                     onPressed: () {
  //                       // context.push(FORGET_PASSWORD);
  //                       // Navigator.push(
  //                       //   context,
  //                       //   MaterialPageRoute(
  //                       //     builder: (context) {
  //                       //       return ForgetPasswordView();
  //                       //     },
  //                       //   ),
  //                       // );
  //                     },
  //                     child: const Text("Forget Password?"),
  //                   ),
  //                   const SizedBox(height: 20),

  //                   Row(
  //                     children: [
  //                       const Text("Don't Have an Account?"),
  //                       TextButton(
  //                         onPressed: () {
  //                           // Navigator.pop(context);
  //                           // context.push(SIGNUP);
  //                           // Navigator.push(
  //                           //   context,
  //                           //   MaterialPageRoute(
  //                           //     builder: (context) {
  //                           //       return SignUpView();
  //                           //     },
  //                           //   ),
  //                           // );
  //                         },
  //                         child: const Text("Sign Up"),
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       } else if (state is LoginLoadingState) {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else if (state is LoginFailureState) {
  //         return Text("Enter fields");
  //         // _onWidgetDidBuild(
  //         //   () {
  //         //     ScaffoldMessenger.of(context).showSnackBar(
  //         //       SnackBar(
  //         //         content: Text(
  //         //           state.error,
  //         //         ),
  //         //         backgroundColor: Colors.red,
  //         //       ),
  //         //     );
  //         //   },
  //         // );
  //       } else if (state is LoginSuccessState) {
  //         _onWidgetDidBuild(
  //           () {
  //             print(state.message);
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text(
  //                   state.message,
  //                 ),
  //                 // backgroundColor: Colors.red,
  //               ),
  //             );

  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const HomeScreen(),
  //               ),
  //             );
  //           },
  //         );
  //       }
  //       return const SizedBox();
  //     },
  //   );
  // }

  // void _onWidgetDidBuild(Function callback) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     callback();
  //   });
  // }

  // submitButton() {
  //   LoginButtonPressed(
  //     input: UserLoginInput(
  //       email: emailController.text,
  //       password: passwordController.text,
  //       deviceId: newtoken,
  //       loginIp: ipAddress,
  //     ),
  //   );
  // }

  // _onLoginButtonPressed() {
  //   _loginBloc.dispatch(LoginButtonPressed(
  //     username: _usernameController.text,
  //     password: _passwordController.text,
  //   ));
  // }

  Widget _LoginButton({required UserLoginInput input}) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomButton(
            color: Colors.blue,
            title: state is LoginLoadingState
                ? const Center(child: CircularProgressIndicator())
                : const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            onClick: () {
              if (_key.currentState!.validate()) {
                state is! LoginLoadingState
                    ?
                    // () =>
                    context.read<LoginBloc>().add(
                          LoginButtonPressed(
                            input: input,
                          ),
                        )
                    : null;
              }
            },
          ),

          // child: ElevatedButton(
          //   // disabledColor: Colors.blueAccent.withOpacity(0.6),
          //   // color: Colors.blueAccent,
          //   onPressed: () {
          //     if (_key.currentState!.validate()) {
          //       // state is LoginInitialState
          //       // ?
          //       // () =>
          //       context.read<LoginBloc>().add(
          //             LoginButtonPressed(
          //               input: input,
          //             ),
          //           );
          //       // : null,
          //     }
          //   },
          //   child: state is LoginLoadingState
          //       ? const Center(child: CircularProgressIndicator())
          //       : const Text('Login'),
          // ),
        );
      },
    );
  }
}

// class _LoginButton extends StatelessWidget {
//   _LoginButton({
//     Key? key,
//     required this.input,
//   }) : super(key: key);
//   UserLoginInput input;
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous != current,
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: CupertinoButton(
//             disabledColor: Colors.blueAccent.withOpacity(0.6),
//             color: Colors.blueAccent,
//             onPressed: state is LoginInitialState
//                 ? () => context.read<LoginBloc>().add(
//                       LoginButtonPressed(
//                         input: input,
//                       ),
//                     )
//                 : null,
//             child: state is LoginLoadingState
//                 ? const Center(child: CircularProgressIndicator())
//                 : const Text('Login'),
//           ),
//         );
//       },
//     );
//   }
// }

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
