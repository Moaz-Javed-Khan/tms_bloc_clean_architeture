import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Features/auth/OTP/data/repositories/OtpRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/OTP/presentation/bloc/otp_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/OTP/presentation/pages/OtpForm.dart';
import 'package:project_cleanarchiteture/Features/auth/Otp/data/datasources/OtpRemoteDatasource.dart';

class OtpView extends StatefulWidget {
  OtpView({
    Key? key,
    required this.email,
  }) : super(key: key);

  String email;

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> with SingleTickerProviderStateMixin {
  OtpBloc? _OtpBloc;

  @override
  void initState() {
    _OtpBloc = OtpBloc(
      otpRepo: OtpRepositoryImple(
        remotedatasources: OtpRemoteDatasourceImpl(),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtpFrom(
        otpBloc: _OtpBloc!,
        email: widget.email,
      ),
    );
  }
}
