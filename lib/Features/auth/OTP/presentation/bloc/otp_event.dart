part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class OtpButtonPressed extends OtpEvent {
  final String otp;
  final String email;

  const OtpButtonPressed({
    required this.otp,
    required this.email,
  });
}
