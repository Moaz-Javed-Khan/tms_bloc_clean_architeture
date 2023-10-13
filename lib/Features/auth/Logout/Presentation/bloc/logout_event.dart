part of 'logout_bloc.dart';

sealed class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}

class LogoutButtonPressed extends LogoutEvent {
  final String token;
  final String deviceId;

  const LogoutButtonPressed({
    required this.token,
    required this.deviceId,
  });

  @override
  List<Object> get props => [];
}
