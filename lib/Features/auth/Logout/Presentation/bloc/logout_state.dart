part of 'logout_bloc.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();
}

final class LogoutInitialState extends LogoutState {
  @override
  List<Object> get props => [];
}

final class LogoutLoadingState extends LogoutState {
  @override
  List<Object> get props => [];
}

final class LogoutSuccessState extends LogoutState {
  String message;

  LogoutSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class LogoutFailureState extends LogoutState {
  String error;

  LogoutFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
