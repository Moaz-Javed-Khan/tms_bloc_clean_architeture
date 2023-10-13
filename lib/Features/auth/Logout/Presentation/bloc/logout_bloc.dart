import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';
import 'package:project_cleanarchiteture/Core/failures.dart';
import 'package:project_cleanarchiteture/Features/auth/Logout/Domain/repositories/LogoutRepository.dart';
import 'package:project_cleanarchiteture/Utils/GeneralResponse.dart';
import 'package:project_cleanarchiteture/Utils/MessageModel.dart';
import 'package:project_cleanarchiteture/Utils/localData.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> with LocalData {
  final LogoutRepository logoutRepo;

  LogoutBloc({required this.logoutRepo}) : super(LogoutInitialState()) {
    on<LogoutButtonPressed>((event, emit) async {
      emit(LogoutLoadingState());

      try {
        await logoutRepo.userLogout(event.deviceId, event.token).then((value) {
          List<CustomError> error = List<CustomError>.empty(growable: true);
          if (value["error"] != null) {
            List<Map<String, dynamic>>.from(value["error"]).forEach((element) {
              error.add((CustomError.fromJson(
                  json.decode(json.encode(element)) as Map<String, dynamic>)));
            });
          }

          var data = GeneralResponse<Message>(
            error.isNotEmpty ? error : null,
            (value["logout"] != null)
                ? (Message.fromJson(value["logout"]))
                : null,
          );
          if (data.data != null) {
            emit(LogoutSuccessState(message: data.data!.message!));

            clearSharedPreferences();
          } else {
            emit(LogoutFailureState(error: data.data!.message.toString()));
          }
        }).catchError((err) {
          emit(LogoutFailureState(
            error: (err as ServerFailure).message,
          ));
        });
      } catch (e) {
        emit(LogoutFailureState(
          error: (e as ServerFailure).message,
        ));
      }
    });
  }

  @override
  void onTransition(Transition<LogoutEvent, LogoutState> transition) {
    super.onTransition(transition);
    debugPrint(transition.toString());
  }

  @override
  void onChange(Change<LogoutState> change) {
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
  void onEvent(LogoutEvent event) {
    super.onEvent(event);
    debugPrint(event.toString());
  }
}
