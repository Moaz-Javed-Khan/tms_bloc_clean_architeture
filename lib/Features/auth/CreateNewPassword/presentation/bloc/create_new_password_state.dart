part of 'create_new_password_bloc.dart';

sealed class CreateNewPasswordState extends Equatable {
  const CreateNewPasswordState();

  @override
  List<Object> get props => [];
}

final class CreateNewPasswordInitial extends CreateNewPasswordState {}

final class CreateNewPasswordLoadingState extends CreateNewPasswordState {}

final class CreateNewPasswordSuccessState extends CreateNewPasswordState {
  final String message;

  const CreateNewPasswordSuccessState({required this.message});
}

final class CreateNewPasswordFailureState extends CreateNewPasswordState {
  final String error;

  const CreateNewPasswordFailureState({required this.error});
}
