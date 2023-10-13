part of 'all_users_bloc.dart';

sealed class AllUsersState extends Equatable {}

final class AllUsersInitial extends AllUsersState {
  @override
  List<Object> get props => [];
}

final class AllUsersLoading extends AllUsersState {
  @override
  List<Object> get props => [];
}

final class AllUsersLoaded extends AllUsersState {
  final List<User> listOfUsers;

  AllUsersLoaded({
    required this.listOfUsers,
  });

  @override
  List<Object> get props => [listOfUsers];
}

final class AllUsersFailure extends AllUsersState {
  final String error;

  AllUsersFailure({required this.error});

  @override
  List<Object> get props => [error];
}
