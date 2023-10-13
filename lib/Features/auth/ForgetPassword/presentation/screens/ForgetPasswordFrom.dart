import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/presentation/bloc/forget_password_bloc.dart';
import 'package:project_cleanarchiteture/Utils/Routing.dart';
import 'package:project_cleanarchiteture/Widgets/CutomButton.dart';

class ForgetPasswordFrom extends StatefulWidget {
  const ForgetPasswordFrom({super.key, required this.forgetPasswordBloc});

  final ForgetPasswordBloc forgetPasswordBloc;

  @override
  State<ForgetPasswordFrom> createState() => _ForgetPasswordFromState();
}

class _ForgetPasswordFromState extends State<ForgetPasswordFrom>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();

  ForgetPasswordBloc get _forgetPasswordBloc => widget.forgetPasswordBloc;

  String enteredEmail = "";

  bool isObscure = true;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordFailureState) {
          print('on screen: submission failure');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.replaceAll('Exception:', '')),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ForgetPasswordSuccessState) {
          print('on screen: success');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );

          context.push(
            OTP,
            extra: emailController.text.toString(),
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => (),
          //   ),
          // );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.tealAccent,
          body: SafeArea(
            child: Column(
              children: [
                Image.asset(
                  "assets/forget.png",
                  width: 200,
                  height: 200,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 32,
                        right: 16.0,
                        bottom: 16.0,
                        left: 16.0,
                      ),
                      child: Column(
                        children: [
                          Form(
                            key: _key,
                            child: TextFormField(
                              onChanged: (value) {
                                print("Value Email: $value");
                                setState(() {
                                  enteredEmail = value;
                                });
                                print("Value Entered Email: $enteredEmail");
                              },
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(
                                      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
                                    ).hasMatch(value)) {
                                  return "Enter Email correctly";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _forgetPasswordButton(
                            email: enteredEmail,
                            // email: emailController.text,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: IconButton(
                                onPressed: () {
                                  context.pushReplacement(SIGNIN);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.teal,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _forgetPasswordButton({required String email}) {
    return BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomButton(
            color: Colors.blue,
            title: state is ForgetPasswordLoadingState
                ? const Center(child: CircularProgressIndicator())
                : const Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            onClick: () {
              setState(() {
                if (_key.currentState!.validate()) {
                  state is! ForgetPasswordLoadingState
                      ?
                      // () =>
                      context.read<ForgetPasswordBloc>().add(
                            ForgetPasswordButtonPressed(
                              email: email,
                            ),
                          )
                      : null;
                }
              });
            },
          ),
        );
      },
    );
  }
}
