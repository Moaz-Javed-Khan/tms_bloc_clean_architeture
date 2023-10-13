part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class LoginInitialState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends LoginState {
  final LoginAdmin loginResponse;

  LoginSuccessState({
    required this.loginResponse,
  });
  @override
  List<Object> get props => [];

  // LoginSuccessState copyWith({message}) {
  //   return LoginSuccessState(
  //     message: message ?? this.message,
  //   );
  // }
}

class LoginFailureState extends LoginState {
  final String error;

  LoginFailureState({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}

// import 'package:equatable/equatable.dart';
// import 'package:formz/formz.dart';

// class LoginState extends Equatable {
//   const LoginState({
//     this.email = "",
//     this.password = "",
//     this.exceptionError = "",
//   });

//   final String email;
//   final String password;
//   final String exceptionError;

//   @override
//   List<Object> get props => [email, password, exceptionError];

//   LoginState copyWith({
//     String? email,
//     String? password,
//     String? error,
//   }) {
//     return LoginState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       exceptionError: error ?? this.exceptionError,
//     );
//   }
// }
