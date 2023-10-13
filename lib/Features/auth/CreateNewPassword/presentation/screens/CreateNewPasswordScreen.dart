import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/Data/repositories/CreateNewPasswordRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/data/datasources/CreateNewPasswordRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/presentation/bloc/create_new_password_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/presentation/screens/CreateNewPasswordFrom.dart';

class CreateNewPasswordView extends StatefulWidget {
  CreateNewPasswordView({
    Key? key,
    required this.email,
    required this.otp,
  }) : super(key: key);

  String email;
  String otp;

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView>
    with SingleTickerProviderStateMixin {
  CreateNewPasswordBloc? _createNewPasswordBloc;

  @override
  void initState() {
    _createNewPasswordBloc = CreateNewPasswordBloc(
      createNewPasswordRepo: CreateNewPasswordRepositoryImple(
        remotedatasources: CreateNewPasswordRemoteDatasourceImpl(),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateNewPasswordFrom(
        createNewPasswordBloc: _createNewPasswordBloc!,
        email: widget.email,
        otp: widget.otp,
      ),
    );
  }
}
