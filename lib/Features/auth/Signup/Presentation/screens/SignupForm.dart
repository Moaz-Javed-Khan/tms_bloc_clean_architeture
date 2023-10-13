import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/entities/AddressModel.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/entities/Name.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/params/UserSignupInput.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Presentation/bloc/signup_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:project_cleanarchiteture/Utils/Routing.dart';
import 'package:project_cleanarchiteture/Widgets/CutomButton.dart';

class SignupFrom extends StatefulWidget {
  const SignupFrom({super.key, required this.signupBloc});

  final SignupBloc signupBloc;

  @override
  State<SignupFrom> createState() => _SignupFromState();
}

class _SignupFromState extends State<SignupFrom>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameEnController = TextEditingController();
  TextEditingController nameArController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressEnController = TextEditingController();
  TextEditingController addressArController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  SignupBloc get _SignupBloc => widget.signupBloc;

  bool isObscure = true;
  final _key = GlobalKey<FormState>();

  String newtoken = "";
  var ipAddress;

  late AnimationController _controller;
  double _offset = 0.0;
  double initailHeight = 10.0;

  void _startAnimationPencil() {
    if (!_controller.isAnimating) {
      _controller.forward(from: 0.0);
    }
  }

  void _stopAnimationPencil() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  void _startAnimationShhh() {
    setState(() {
      initailHeight = 80;
    });
  }

  void _stopAnimationShhh() {
    setState(() {
      initailHeight = 10.0;
    });
  }

  Future<void> sizeChange() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      initailHeight = 80;
    });
  }

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
    requestPermission();
    getToken();
    fetchPublicIP();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {
          _offset = _controller.value * 50.0;
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupFailureState) {
          print('on screen: submission failure');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.replaceAll('Exception:', '')),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is SignupSuccessState) {
          print('on screen: success');

          context.pushReplacement(SIGNIN);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => SignInView(),
          //   ),
          // );
        }
      },
      builder: (context, state) {
        return Form(
          key: _key,
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  children: [
                    Transform.translate(
                      offset:
                          Offset((deviceWidth * 0.5), -(deviceHeight * 0.31)),
                      child: Transform.rotate(
                        angle: 40,
                        child: Container(
                          color: Colors.blue,
                          width: 500,
                          height: 500,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        SizedBox(height: (deviceHeight - 500)),
                        const Text(
                          "Create Account,",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                          ),
                        ),
                        const Text(
                          "Sign up to started!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 30),
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
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              _startAnimationPencil();
                            } else {
                              _stopAnimationPencil();
                            }
                          },
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
                            if (value!.isEmpty ||
                                !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                              return "Enter Name correctly";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              _startAnimationPencil();
                            } else {
                              _stopAnimationPencil();
                            }
                          },
                          controller: nameEnController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            labelText: 'Full Name in English',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Name";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              _startAnimationPencil();
                            } else {
                              _stopAnimationPencil();
                            }
                          },
                          controller: nameArController,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            labelText: 'الاسم الكامل بالعربية',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^(?:[+0]9)?[0-9]{10,12}$')
                                    .hasMatch(value)) {
                              return "Enter Phone Number correctly";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              _startAnimationPencil();
                            } else {
                              _stopAnimationPencil();
                            }
                          },
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            labelText: 'Phone Number',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Address";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              _startAnimationPencil();
                            } else {
                              _stopAnimationPencil();
                            }
                          },
                          controller: addressEnController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            labelText: 'Address in English',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Address";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              _startAnimationPencil();
                            } else {
                              _stopAnimationPencil();
                            }
                          },
                          controller: addressArController,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            labelText: 'العنوان بالعربية',
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
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              _startAnimationPencil();
                            } else {
                              _stopAnimationPencil();
                            }
                          },
                          controller: passwordController,
                          obscureText: isObscure,
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
                                  if (!isObscure) {
                                    _startAnimationShhh();
                                  } else {
                                    _stopAnimationShhh();
                                  }
                                  // sizeChange();
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: _SignupButton(
                            input: UserSignupInput(
                              email: emailController.text,
                              password: passwordController.text,
                              deviceId: newtoken,
                              fullName: Name(
                                en: nameEnController.text,
                                ar: nameArController.text,
                              ),
                              phoneNumber: phoneNumberController.text,
                              address: Address(
                                en: addressEnController.text,
                                ar: addressArController.text,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already Have an Account?"),
                            TextButton(
                              onPressed: () {
                                context.pushReplacement(SIGNIN);

                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return SignInView();
                                //     },
                                //   ),
                                // );
                              },
                              child: const Text("Sign In"),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget _SignupButton({required UserSignupInput input}) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomButton(
            color: Colors.blue,
            title: state is SignupLoadingState
                ? const Center(child: CircularProgressIndicator())
                : const Text(
                    'Signup',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            onClick: () {
              if (_key.currentState!.validate()) {
                state is! SignupLoadingState
                    ?
                    // () =>
                    context.read<SignupBloc>().add(
                          SignupButtonPressed(
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
          //       // state is SignupInitialState
          //       // ?
          //       // () =>
          //       context.read<SignupBloc>().add(
          //             SignupButtonPressed(
          //               input: input,
          //             ),
          //           );
          //       // : null,
          //     }
          //   },
          //   child: state is SignupLoadingState
          //       ? const Center(child: CircularProgressIndicator())
          //       : const Text('Signup'),
          // ),
        );
      },
    );
  }
}
