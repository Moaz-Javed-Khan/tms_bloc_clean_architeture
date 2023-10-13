import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/RoleLovResponseModel.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/UserLovResponseModel.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/UserModel.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/find_user_by_id_repository.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/roles_lov_repository.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/users_lov_repository.dart';
import 'package:project_cleanarchiteture/Utils/GeneralResponse.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<LovEvent, UserState> {
  final RoleLovRepository roleLovRepo;
  final UserLovRepository userLovRepo;
  final FindUserByIdRepository findUserByIdRepo;

  UserBloc({
    required this.roleLovRepo,
    required this.userLovRepo,
    required this.findUserByIdRepo,
  }) : super(InitailState()) {
    // on<LoadRoleLovEvent>(loadEvent);

    on<LoadRoleLovEvent>(loadRoleLovEvent);
    on<LoadUserLovEvent>(loadUserLovEvent);
    on<FindUserByIdEvent>(findUserByIdEvent);

    // on<LoadUserEvent>(loadUserEvent);
    // on<CreateUserEvent>(createUserEvent);
    // on<UpdateUserEvent>(updateUserEvent);
    // on<DeleteUserEvent>(deleteUserEvent);
  }

  // FutureOr<void> loadUserEvent(
  //   LoadUserEvent event,
  //   Emitter<UserState> emit,
  // ) {}
  // FutureOr<void> createUserEvent(
  //   CreateUserEvent event,
  //   Emitter<UserState> emit,
  // ) {}
  // FutureOr<void> updateUserEvent(
  //   UpdateUserEvent event,
  //   Emitter<UserState> emit,
  // ) {}
  // FutureOr<void> deleteUserEvent(
  //   DeleteUserEvent event,
  //   Emitter<UserState> emit,
  // ) {}

  FutureOr<void> loadRoleLovEvent(
    LoadRoleLovEvent event,
    Emitter<UserState> emit,
  ) async {
    print("role Button Pressed event received");

    emit(RoleLovLoadingState());
    print("Emitted role Loading State");

    try {
      await roleLovRepo.roleLov(token: "wqwq").then((value) {
        List<RoleLovResponse> rolelist =
            List<RoleLovResponse>.empty(growable: true);
        List<CustomError> error = List<CustomError>.empty(growable: true);
        if (value["error"] != null) {
          List<Map<String, dynamic>>.from(value["error"]).forEach((element) {
            error.add((CustomError.fromJson(
                json.decode(json.encode(element)) as Map<String, dynamic>)));
          });
        }

        if (value["getAllRoleslov"] != null) {
          List<Map<String, dynamic>>.from(value["getAllRoleslov"])
              .forEach((element) {
            rolelist.add((RoleLovResponse.fromJson(
                json.decode(json.encode(element)) as Map<String, dynamic>)));
          });
          var data = GeneralResponse<List<RoleLovResponse>>(
            error.isNotEmpty ? error : null,
            value["getAllRoleslov"] != null ? rolelist : null,
          );

          print("role loading successful");

          emit(
            RoleLovLoadedState(
              message: "loaded Successfully",
              listOfRoles: data.data!,
            ),
          );

          print("role loading successful 2");

          // if (data.data != null) {
          //   listOfRoles = data.data!;
          // } else {
          //   listOfRoles = [];
          // }
        }
      });
    } catch (e) {
      // listOfRoles = [];
      print("role loading failed: $e");
      emit(
        RoleLovErrorState(
          error: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> loadUserLovEvent(
    LoadUserLovEvent event,
    Emitter<UserState> emit,
  ) async {
    // List<RoleLovResponse> listOfUsers;

    print("load User Button Pressed event received");

    emit(UserLovLoadingState());
    print("Emitted User Loading State");

    try {
      await userLovRepo.userLov(token: "wqwq").then((value) {
        List<UserLovResponse> userlist =
            List<UserLovResponse>.empty(growable: true);
        List<CustomError> error = List<CustomError>.empty(growable: true);
        if (value["error"] != null) {
          List<Map<String, dynamic>>.from(value["error"]).forEach((element) {
            error.add((CustomError.fromJson(
                json.decode(json.encode(element)) as Map<String, dynamic>)));
          });
        }

        if (value["getAllUserslov"] != null) {
          List<Map<String, dynamic>>.from(value["getAllUserslov"])
              .forEach((element) {
            userlist.add((UserLovResponse.fromJson(
                json.decode(json.encode(element)) as Map<String, dynamic>)));
          });
          var data = GeneralResponse<List<UserLovResponse>>(
            error.isNotEmpty ? error : null,
            value["getAllUserslov"] != null ? userlist : null,
          );

          print("User loading successful");

          emit(UserLovLoadedState(
            message: "loaded user Successfully",
            listOfUsers: data.data!,
          ));

          print("User loading successful 2");

          // if (data.data != null) {
          //   listOfUsers = data.data!;
          // } else {
          //   listOfUsers = [];
          // }
        }
      });

      // print("Response: $response");
    } catch (e) {
      // listOfUsers = [];

      print("User loading failed: $e");
      emit(
        UserLovErrorState(
          error: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> findUserByIdEvent(
    event,
    Emitter<UserState> emit,
  ) async {
    emit(FindUserByIdLoadingState());

    try {
      await findUserByIdRepo
          .findUserById(userId: event.userId, token: "wqwq")
          .then((value) {
        List<CustomError> error = List<CustomError>.empty(growable: true);

        if (value["error"] != null) {
          List<Map<String, dynamic>>.from(value["error"]).forEach((element) {
            error.add((CustomError.fromJson(
                json.decode(json.encode(element)) as Map<String, dynamic>)));
          });
        }

        var data = GeneralResponse<User>(
          error.isNotEmpty ? error : null,
          (value["getUserById"] != null)
              ? (User.fromJson(value["getUserById"]))
              : null,
        );
        if (data.data != null) {
          emit(FindUserByIdLoadedState(
              message: "loaded", userDetails: data.data!));

          print("User data: ${data.data}");
        } else {
          emit(FindUserByIdErrorState(error: "Data not found"));
        }
      }).catchError((err) {
        emit(FindUserByIdErrorState(error: "Data not found"));
      });
    } catch (e) {
      emit(FindUserByIdErrorState(error: "Data not found"));
    }
  }

  // FutureOr<void> loadEvent(
  //     LoadRoleLovEvent event, Emitter<UserState> emit) async {
  //   print("load User Button Pressed event received");
  //   emit(LoadingState());
  //   print("Emitted User Loading State");
  //   try {
  //     final response = await roleLovRepo.roleLov(token: "wqwq").then((value) {
  //       List<UserLovResponse> rolelist =
  //           List<UserLovResponse>.empty(growable: true);
  //       List<CustomError> error = List<CustomError>.empty(growable: true);
  //       if (value["error"] != null) {
  //         List<Map<String, dynamic>>.from(value["error"]).forEach((element) {
  //           error.add((CustomError.fromJson(
  //               json.decode(json.encode(element)) as Map<String, dynamic>)));
  //         });
  //       }
  //       if (value["getAllUserslov"] != null) {
  //         List<Map<String, dynamic>>.from(value["getAllUserslov"])
  //             .forEach((element) {
  //           rolelist.add((UserLovResponse.fromJson(
  //               json.decode(json.encode(element)) as Map<String, dynamic>)));
  //         });
  //         var data = GeneralResponse<List<UserLovResponse>>(
  //           error.isNotEmpty ? error : null,
  //           value["getAllUserslov"] != null ? rolelist : null,
  //         );
  //         print("User loading successful");
  //         emit(LoadedState(
  //           message: "loaded user Successfully",
  //           listOfUsers: data.data!,
  //           listOfRoles: data.data!,
  //         ));
  //         print("User loading successful 2");
  //         // if (data.data != null) {
  //         //   listOfUsers = data.data!;
  //         // } else {
  //         //   listOfUsers = [];
  //         // }
  //       }
  //     });
  //     // print("Response: $response");
  //   } catch (e) {
  //     // listOfUsers = [];
  //     print("User loading failed: $e");
  //     emit(
  //       ErrorState(
  //         error: e.toString(),
  //       ),
  //     );
  //   }
  // }

  @override
  void onTransition(Transition<LovEvent, UserState> transition) {
    super.onTransition(transition);
    debugPrint(transition.toString());
  }

  @override
  void onChange(Change<UserState> change) {
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
  void onEvent(LovEvent event) {
    super.onEvent(event);
    debugPrint(event.toString());
  }
}
