part of 'user_bloc.dart';

sealed class UserState extends Equatable {}

final class InitailState extends UserState {
  @override
  List<Object> get props => [];
}

//Roles
final class RoleLovLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class RoleLovLoadedState extends UserState {
  RoleLovLoadedState({
    required this.message,
    required this.listOfRoles,
  });

  final String message;
  final List<RoleLovResponse> listOfRoles;

  @override
  List<Object> get props => [listOfRoles];
}

final class RoleLovErrorState extends UserState {
  RoleLovErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}

//Users
final class UserLovLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class UserLovLoadedState extends UserState {
  UserLovLoadedState({
    required this.message,
    required this.listOfUsers,
  });

  final String message;
  final List<UserLovResponse> listOfUsers;

  @override
  List<Object> get props => [listOfUsers];
}

final class UserLovErrorState extends UserState {
  UserLovErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}

//find user by id
final class FindUserByIdLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class FindUserByIdLoadedState extends UserState {
  FindUserByIdLoadedState({
    required this.message,
    required this.userDetails,
  });

  final String message;
  final User userDetails;

  @override
  List<Object> get props => [userDetails];
}

final class FindUserByIdErrorState extends UserState {
  FindUserByIdErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}


// final class LoadingState extends UserState {}

// final class LoadedState extends UserState {
//   LoadedState({
//     required this.message,
//     required this.listOfRoles,
//     required this.listOfUsers,
//   });

//   String message;
//   List<UserLovResponse> listOfRoles;
//   List<UserLovResponse> listOfUsers;
// }

// final class ErrorState extends UserState {
//   ErrorState({required this.error});

//   String error;
// }