import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';
import 'package:project_cleanarchiteture/Core/failures.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/domain/repositories/ForgetPasswordRepository.dart';
import 'package:project_cleanarchiteture/Utils/GeneralResponse.dart';
import 'package:project_cleanarchiteture/Utils/MessageModel.dart';

part 'create_new_password_event.dart';
part 'create_new_password_state.dart';

class CreateNewPasswordBloc
    extends Bloc<CreateNewPasswordEvent, CreateNewPasswordState> {
  final CreateNewPasswordRepository createNewPasswordRepo;

  CreateNewPasswordBloc({required this.createNewPasswordRepo})
      : super(CreateNewPasswordInitial()) {
    on<CreateNewPasswordButtonPressed>((event, emit) async {
      emit(CreateNewPasswordLoadingState());

      try {
        await createNewPasswordRepo
            .userCreateNewPassword(
          event.newPassword,
          event.email,
          event.otp,
        )
            .then((value) {
          List<CustomError> error = List<CustomError>.empty(growable: true);
          if (value["error"] != null) {
            List<Map<String, dynamic>>.from(value["error"]).forEach((element) {
              error.add((CustomError.fromJson(
                  json.decode(json.encode(element)) as Map<String, dynamic>)));
            });
          }

          var data = GeneralResponse<Message>(
            error.isNotEmpty ? error : null,
            (value["resetPassword"] != null)
                ? (Message.fromJson(value["resetPassword"]))
                : null,
          );
          if (data.data != null) {
            emit(CreateNewPasswordSuccessState(message: data.data!.message!));
          } else {
            emit(CreateNewPasswordFailureState(
                error: data.data!.message.toString()));
          }
        }).catchError((err) {
          emit(CreateNewPasswordFailureState(
            error: (err as ServerFailure).message,
          ));
        });
      } catch (e) {
        emit(CreateNewPasswordFailureState(
          error: (e as ServerFailure).message,
        ));
      }

      //
      //
      // print("CreateNew Password Button Pressed event received");

      // emit(CreateNewPasswordLoadingState());
      // print("Emitted CreateNew Password Loading State");

      // try {
      //   final response = await createNewPasswordRepo.userCreateNewPassword(
      //     event.newPassword,
      //     event.email,
      //     event.otp,
      //   );
      //   print("Response: $response");
      //   // if (response.isLeft()) {
      //   //   final failure = response.fold((failure) => failure, (_) => null);
      //   //   print("CreateNewPassword failed: $failure");
      //   //   emit(CreateNewPasswordFailureState(error: failure.toString()));
      //   // } else {
      //   print("CreateNewPassword successful");

      //   emit(const CreateNewPasswordSuccessState(
      //     message: "Password Changed Successfully",
      //   ));
      //   print("CreateNewPassword successful 2");
      //   // }
      // } catch (e) {
      //   print("CreateNewPassword failed: $e");
      //   emit(
      //     CreateNewPasswordFailureState(
      //       error: e.toString(),
      //     ),
      //   );
      // }
    });
  }

  @override
  void onTransition(
      Transition<CreateNewPasswordEvent, CreateNewPasswordState> transition) {
    super.onTransition(transition);
    debugPrint(transition.toString());
  }

  @override
  void onChange(Change<CreateNewPasswordState> change) {
    super.onChange(change);
    debugPrint(change.toString());
    debugPrint(change.currentState.toString());
    debugPrint(change.nextState.toString());
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    debugPrint(error.toString());
  }

  @override
  void onEvent(CreateNewPasswordEvent event) {
    super.onEvent(event);
    debugPrint(event.toString());
  }
}
