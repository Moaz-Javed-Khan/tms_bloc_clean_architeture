part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();
}

class SignupButtonPressed extends SignupEvent {
  final UserSignupInput input;
  const SignupButtonPressed({required this.input});
  @override
  List<Object> get props => [];
}
