part of 'user_bloc.dart';

sealed class LovEvent extends Equatable {}

class LoadRoleLovEvent extends LovEvent {
  @override
  List<Object> get props => [];
}

class LoadUserLovEvent extends LovEvent {
  @override
  List<Object> get props => [];
}

class FindUserByIdEvent extends LovEvent {
  final int userId;

  FindUserByIdEvent({required this.userId});

  @override
  List<Object> get props => [];
}

// class LoadUserEvent extends UserEvent {}

// class CreateUserEvent extends UserEvent {}

// class UpdateUserEvent extends UserEvent {}

// class DeleteUserEvent extends UserEvent {}
