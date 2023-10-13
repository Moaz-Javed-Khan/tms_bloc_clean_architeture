import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/UserModel.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Domain/entities/AdminSignInResponse.dart';
import 'package:project_cleanarchiteture/Features/pagination/bloc/all_users_bloc.dart';
import 'package:project_cleanarchiteture/Features/pagination/repo/GetAllUsersRequestModel.dart';
import 'package:project_cleanarchiteture/Features/pagination/repo/get_all_user_repository.dart';
import 'package:project_cleanarchiteture/Utils/Extensions.dart';
import 'package:project_cleanarchiteture/Utils/localData.dart';

class AllUsersScreen extends StatefulWidget {
  AllUsersScreen({super.key});

  final userbloc = AllUsersBloc(getAllUsersRepo: GetAllUsersRepository());

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> with LocalData {
  LoginAdmin? userdata;
  List<User> userList = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onScroll(
      // int pageStart,
      ) {
    if (isBottom) {
      context.read<AllUsersBloc>().add(AllUsersLoadEvent(
            input: GetAllUsersRequest(
              active: false,
              fullName: null,
              pageStart: 10, //pageStart,
              roleId: null,
              status: "Approved",
            ),
            token: userdata?.token ?? "",
          ));
    }
  }

  bool get isBottom {
    return (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) &&
        !_scrollController.position.outOfRange;
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(onScroll);

    getUserinfo(USER_INFO);

    Future.delayed(const Duration(seconds: 3), () {
      var userd = savedLoginData;

      userdata = LoginAdmin.fromJson(jsonDecode(userd!));

      context.read<AllUsersBloc>().add(AllUsersLoadEvent(
            input: GetAllUsersRequest(
              active: false,
              fullName: null,
              pageStart: widget.userbloc.pagestart,
              roleId: null,
              status: "Approved",
            ),
            token: userdata?.token ?? "",
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users"),
      ),
      body: allUsers(),
    );
  }

  Widget allUsers() {
    return BlocBuilder<AllUsersBloc, AllUsersState>(
      builder: (context, state) {
        // if (state is AllUsersInitial) {
        //   context.read<AllUsersBloc>().add(AllUsersLoadEvent(
        //         input: GetAllUsersRequest(
        //           active: false,
        //           fullName: null,
        //           pageStart: widget.userbloc.pagestart,
        //           roleId: null,
        //           status: "Approved",
        //         ),
        //         token: userdata?.token ?? "",
        //       ));
        // }
        if (state is AllUsersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is AllUsersLoaded) {
          userList = state.listOfUsers;
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  userList[index].email.toString(),
                ),
              );
            },
          );
        }
        if (state is AllUsersFailure) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Error"),
              Text(state.error),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
