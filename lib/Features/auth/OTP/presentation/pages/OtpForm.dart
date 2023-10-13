import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:project_cleanarchiteture/Features/auth/OTP/presentation/bloc/otp_bloc.dart';
import 'package:project_cleanarchiteture/Utils/Routing.dart';
import 'package:project_cleanarchiteture/Widgets/CutomButton.dart';

class OtpFrom extends StatefulWidget {
  const OtpFrom({
    super.key,
    required this.otpBloc,
    required this.email,
  });

  final OtpBloc otpBloc;

  final String email;

  @override
  State<OtpFrom> createState() => _OtpFromState();
}

class _OtpFromState extends State<OtpFrom> with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameEnController = TextEditingController();
  TextEditingController nameArController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressEnController = TextEditingController();
  TextEditingController addressArController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String OTP = "";

  OtpBloc get _otpBloc => widget.otpBloc;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpFailureState) {
          print('on screen: submission failure');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.replaceAll('Exception:', '')),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is OtpSuccessState) {
          print('on screen: success');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );

          context.goNamed(
            'newPass',
            pathParameters: {
              'email': widget.email,
              'otp': OTP,
            },
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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Verification Code",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "We mailed you a code at ${widget.email}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                const Text(
                  "Please enter it below",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 24),
                OtpTextField(
                  numberOfFields: 4,
                  showFieldAsBox: false,
                  borderColor: Colors.black,
                  //set to true to show as box or false to show as dash
                  fieldWidth: 50.0,
                  keyboardType: TextInputType.number,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here

                    setState(() {
                      OTP = code;
                    });

                    print("otp code in on change: $code");
                    print("otp in on change: $OTP");
                  },
                  onSubmit: (String code) {
                    //handle validation or checks here

                    setState(() {
                      OTP = code;
                    });

                    print("otp code in on submit: $code");
                    print("otp in on submit: $OTP");
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: _OtpButton(
                    otp: OTP,
                    email: widget.email,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
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
                  child: const Text("Didn't get code?"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _OtpButton({
    required String otp,
    required String email,
  }) {
    print("OTP: $otp");

    return BlocBuilder<OtpBloc, OtpState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomButton(
            color: Colors.blue,
            title: state is OtpLoadingState
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
              state is! OtpLoadingState
                  ? setState(() {
                      context.read<OtpBloc>().add(
                            OtpButtonPressed(
                              otp: otp,
                              email: email,
                            ),
                          );
                    })
                  : null;
            },
          ),
        );
      },
    );
  }
}
