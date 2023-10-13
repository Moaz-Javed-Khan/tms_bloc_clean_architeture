part of 'otp_bloc.dart';

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

final class OtpInitialState extends OtpState {}

final class OtpLoadingState extends OtpState {}

final class OtpSuccessState extends OtpState {
  final String message;

  const OtpSuccessState({required this.message});
}

final class OtpFailureState extends OtpState {
  final String error;

  const OtpFailureState({required this.error});
}
