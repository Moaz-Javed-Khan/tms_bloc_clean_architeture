part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class LoginButtonPressed extends LoginEvent {
  final UserLoginInput input;
  LoginButtonPressed({required this.input});

  @override
  List<Object> get props => [];

  // @override
  // String toString() => 'LoginButtonPressed { inout: $input }';
}
