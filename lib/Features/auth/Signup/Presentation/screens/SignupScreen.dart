import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Data/datasources/SignupRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Data/repositories/SignupRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Presentation/bloc/signup_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Presentation/screens/SignupForm.dart';

class SignUpView extends StatefulWidget {
  SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView>
    with SingleTickerProviderStateMixin {
  SignupBloc? _signupBloc;

  @override
  void initState() {
    _signupBloc = SignupBloc(
      signupRepo: SignupRepositoryImple(
        remotedatasources: SignupRemoteDatasourceImpl(),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignupFrom(
        signupBloc: _signupBloc!,
      ),
    );
  }
}
