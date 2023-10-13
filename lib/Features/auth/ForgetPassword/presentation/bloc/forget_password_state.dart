part of 'forget_password_bloc.dart';

sealed class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object> get props => [];
}

final class ForgetPasswordInitialState extends ForgetPasswordState {}

final class ForgetPasswordLoadingState extends ForgetPasswordState {}

final class ForgetPasswordSuccessState extends ForgetPasswordState {
  final String message;

  const ForgetPasswordSuccessState({required this.message});
}

final class ForgetPasswordFailureState extends ForgetPasswordState {
  final String error;

  const ForgetPasswordFailureState({required this.error});
}
