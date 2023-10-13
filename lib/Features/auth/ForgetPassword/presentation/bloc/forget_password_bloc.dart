import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';
import 'package:project_cleanarchiteture/Core/failures.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/Domain/repositories/ForgetPasswordRepository.dart';
import 'package:project_cleanarchiteture/Utils/GeneralResponse.dart';
import 'package:project_cleanarchiteture/Utils/MessageModel.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final ForgetPasswordRepository forgetPasswordRepo;

  ForgetPasswordBloc({required this.forgetPasswordRepo})
      : super(ForgetPasswordInitialState()) {
    on<ForgetPasswordButtonPressed>((event, emit) async {
      emit(ForgetPasswordLoadingState());

      try {
        await forgetPasswordRepo.userForgetPassword(event.email).then((value) {
          List<CustomError> error = List<CustomError>.empty(growable: true);
          if (value["error"] != null) {
            List<Map<String, dynamic>>.from(value["error"]).forEach((element) {
              error.add((CustomError.fromJson(
                  json.decode(json.encode(element)) as Map<String, dynamic>)));
            });
          }

          var data = GeneralResponse<Message>(
            error.isNotEmpty ? error : null,
            (value["requestReset"] != null)
                ? (Message.fromJson(value["requestReset"]))
                : null,
          );
          if (data.data != null) {
            emit(ForgetPasswordSuccessState(
              message: data.data!.message!,
            ));
          } else {
            emit(ForgetPasswordFailureState(
                error:
                    "No data Found: ${data.error!.first.extensions.code.message}"));
          }
        }).catchError((err) {
          emit(ForgetPasswordFailureState(
            error: (err as ServerFailure).message,
          ));
        });
      } catch (e) {
        emit(ForgetPasswordFailureState(
          error: (e as ServerFailure).message,
        ));
      }

      //
      //
      // print("Forget Password Button Pressed event received");
      // emit(ForgetPasswordLoadingState());
      // print("Emitted Forget Password Loading State");
      // try {
      //   final response =
      //       await forgetPasswordRepo.userForgetPassword(event.email);
      //   print("Response: $response");
      //   // if (response.isLeft()) {
      //   //   final failure = response.fold((failure) => failure, (_) => null);
      //   //   print("ForgetPassword failed: $failure");
      //   //   emit(ForgetPasswordFailureState(error: failure.toString()));
      //   // } else {
      //   print("ForgetPassword successful");

      //   emit(const ForgetPasswordSuccessState(
      //     message: "OTP sent Successfully",
      //   ));
      //   print("ForgetPassword successful 2");
      //   // }
      // } catch (e) {
      //   print("ForgetPassword failed: $e");
      //   emit(
      //     ForgetPasswordFailureState(
      //       error: e.toString(),
      //     ),
      //   );
      // }
    });
  }

  @override
  void onTransition(
      Transition<ForgetPasswordEvent, ForgetPasswordState> transition) {
    super.onTransition(transition);
    debugPrint(transition.toString());
  }

  @override
  void onChange(Change<ForgetPasswordState> change) {
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
  void onEvent(ForgetPasswordEvent event) {
    super.onEvent(event);
    debugPrint(event.toString());
  }
}
