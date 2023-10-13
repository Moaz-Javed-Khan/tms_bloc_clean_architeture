import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Data/datasource/LoginRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Data/repositories/LoginRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Presentation/bloc/login_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Presentation/screens/LoginForm.dart';

class SignInView extends StatefulWidget {
  SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView>
    with SingleTickerProviderStateMixin {
  LoginBloc? _loginBloc;

  @override
  void initState() {
    _loginBloc = LoginBloc(
      loginRepo:
          LoginRepositoryImple(remotedatasources: LoginRemoteDatasourceImpl()),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginFrom(
        loginBloc: _loginBloc!,
      ),
    );
  }

  // @override
  // void dispose() {
  //   _loginBloc?.dispose();
  //   super.dispose();
  // }

  // Widget _error(String error_msg) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(error_msg)),
  //     );
  //   });
  //   widget.controller.change(null, status: RxStatus.empty());
  //   return SignInButton();
  // }

  // Widget SignInButton() => CustomButton(
  //       name: "Sign In",
  //       onClick: () {
  //         // widget.controller.change(null, status: RxStatus.loading());
  //         if (_key.currentState!.validate()) {
  //           widget.controller.loginUser(UserLoginRequest(
  //             loginIp: widget.controller.ipAddress,
  //             deviceId: newtoken,
  //             email: emailController.text.toString(),
  //             password: passwordController.text.toString(),
  //           ));
  //         }
  //       },
  //       color: Colors.teal.shade300,
  //     );
}
