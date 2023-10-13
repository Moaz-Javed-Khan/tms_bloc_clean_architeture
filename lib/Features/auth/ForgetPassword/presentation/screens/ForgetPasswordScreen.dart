import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/Data/repositories/ForgetPasswordRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/data/datasources/ForgetPasswordRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/presentation/bloc/forget_password_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/presentation/screens/ForgetPasswordFrom.dart';

class ForgetPasswordView extends StatefulWidget {
  ForgetPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView>
    with SingleTickerProviderStateMixin {
  ForgetPasswordBloc? _forgetPasswordBloc;

  @override
  void initState() {
    _forgetPasswordBloc = ForgetPasswordBloc(
      forgetPasswordRepo: ForgetPasswordRepositoryImple(
        remotedatasources: ForgetPasswordRemoteDatasourceImpl(),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForgetPasswordFrom(
        forgetPasswordBloc: _forgetPasswordBloc!,
      ),
    );
  }
}
