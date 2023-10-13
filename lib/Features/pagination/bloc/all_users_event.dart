part of 'all_users_bloc.dart';

abstract class AllUsersEvent extends Equatable {}

class AllUsersLoadEvent extends AllUsersEvent {
  GetAllUsersRequest input;
  String token;

  AllUsersLoadEvent({
    required this.input,
    required this.token,
  });

  @override
  List<Object?> get props => [];
}
