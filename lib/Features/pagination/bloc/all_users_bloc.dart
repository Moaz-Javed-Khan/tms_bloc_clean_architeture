import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';
import 'package:project_cleanarchiteture/Features/pagination/repo/GetAllUsersRequestModel.dart';
import 'package:project_cleanarchiteture/Features/pagination/repo/GetAllUsersResponseModel.dart';
import 'package:project_cleanarchiteture/Features/pagination/repo/get_all_user_repository.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/UserModel.dart';
import 'package:project_cleanarchiteture/Utils/GeneralResponse.dart';

part 'all_users_event.dart';
part 'all_users_state.dart';

class AllUsersBloc extends Bloc<AllUsersEvent, AllUsersState> {
  final GetAllUsersRepository getAllUsersRepo;

  List<User> userList = [];
  int totalCount = 0;
  int pagestart = 0;

  AllUsersBloc({required this.getAllUsersRepo}) : super(AllUsersInitial()) {
    on<AllUsersLoadEvent>((event, emit) async {
      emit(AllUsersLoading());

      try {
        // loadMore = true;
        await getAllUsersRepo
            .getAllUsers(
          input: event.input,
          token: event.token,
        )
            .then((value) {
          List<CustomError> error = List<CustomError>.empty(growable: true);

          if (value["error"] != null) {
            List<Map<String, dynamic>>.from(value["error"]).forEach((element) {
              error.add((CustomError.fromJson(
                  json.decode(json.encode(element)) as Map<String, dynamic>)));
            });
          }

          print("value[]: ${value["getAllUser"]}");

          Map<String, dynamic>? responseJson = value["getAllUser"];

          print("responseJson: $responseJson");

          var data = GeneralResponse<GetAllUsersResponse>(
            error.isNotEmpty ? error : null,

            // responseJson != null
            //     ? GetAllUsersResponse.fromJson(responseJson)
            //     : null,

            // GetAllUsersResponse.fromJson(responseJson),

            value["getAllUser"] != null
                ? GetAllUsersResponse.fromJson(value["getAllUser"])
                : null,

            // GetAllUsersResponse.fromJson(value["getAllUser"]),
          );

          print("data.data: ${data.data}");
          print("data.error: ${data.error}");

          // loadMore = false;
          if (data.data != null) {
            totalCount = data.data!.totalCount!;
            pagestart = data.data!.pageStart!;

            userList += data.data!.users!;

            emit(AllUsersLoaded(
              listOfUsers: userList,
            ));
          } else {
            emit(AllUsersFailure(error: "No data Found"));
          }
          //jsonEncode(value);
        }).catchError((err) {
          emit(AllUsersFailure(error: err.toString()));
        });
      } catch (e) {
        emit(AllUsersFailure(error: e.toString()));
      }
    });
  }

  @override
  void onTransition(Transition<AllUsersEvent, AllUsersState> transition) {
    super.onTransition(transition);
    debugPrint(transition.toString());
  }

  @override
  void onChange(Change<AllUsersState> change) {
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
  void onEvent(AllUsersEvent event) {
    super.onEvent(event);
    debugPrint(event.toString());
  }
}
