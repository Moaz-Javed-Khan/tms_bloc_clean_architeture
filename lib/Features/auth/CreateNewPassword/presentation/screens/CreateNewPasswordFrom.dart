import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/presentation/bloc/create_new_password_bloc.dart';

import 'package:project_cleanarchiteture/Utils/Routing.dart';
import 'package:project_cleanarchiteture/Widgets/CutomButton.dart';

class CreateNewPasswordFrom extends StatefulWidget {
  CreateNewPasswordFrom({
    super.key,
    required this.createNewPasswordBloc,
    required this.otp,
    required this.email,
  });

  final CreateNewPasswordBloc createNewPasswordBloc;
  String otp;
  String email;

  @override
  State<CreateNewPasswordFrom> createState() => _CreateNewPasswordFromState();
}

class _CreateNewPasswordFromState extends State<CreateNewPasswordFrom>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();

  CreateNewPasswordBloc get _createNewPasswordBloc =>
      widget.createNewPasswordBloc;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _key = GlobalKey<FormState>();

  String newPassword = "";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateNewPasswordBloc, CreateNewPasswordState>(
      listener: (context, state) {
        if (state is CreateNewPasswordFailureState) {
          print('on screen: submission failure');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.replaceAll('Exception:', '')),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is CreateNewPasswordSuccessState) {
          print('on screen: success');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );

          context.push(SIGNIN);

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
                      child: Form(
                        key: _key,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Password";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: newPasswordController,
                                decoration: const InputDecoration(
                                  labelText: 'New Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    newPassword = value;
                                  });
                                },
                                validator: (value) {
                                  if (newPasswordController.text.toString() ==
                                      confirmPasswordController.text
                                          .toString()) {
                                    return null;
                                  } else {
                                    return 'Both passwords should be same';
                                  }
                                },
                                controller: confirmPasswordController,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              createNewPasswordButton(
                                newPassword: newPassword,
                                email: widget.email,
                                otp: widget.otp,
                              )
                            ],
                          ),
                        ),
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

  Widget createNewPasswordButton({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    return BlocBuilder<CreateNewPasswordBloc, CreateNewPasswordState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomButton(
            color: Colors.blue,
            title: state is CreateNewPasswordLoadingState
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
              if (_key.currentState!.validate()) {
                state is! CreateNewPasswordLoadingState
                    ?
                    // () =>
                    context.read<CreateNewPasswordBloc>().add(
                          CreateNewPasswordButtonPressed(
                            newPassword: newPassword,
                            email: email,
                            otp: otp,
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
}
