import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_cleanarchiteture/Features/CRUD/bloc/user_bloc.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/RoleLovResponseModel.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/UserLovResponseModel.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/find_user_by_id_repository.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/roles_lov_repository.dart';
import 'package:project_cleanarchiteture/Features/CRUD/repo/users_lov_repository.dart';
import 'package:project_cleanarchiteture/Features/auth/Logout/Presentation/LogoutButton/LogoutButton.dart';
import 'package:project_cleanarchiteture/Utils/Extensions.dart';
import 'package:project_cleanarchiteture/Utils/Routing.dart';

// class UserPage extends StatelessWidget {
//   const UserPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => UserBloc(
//         roleLovRepo: RoleLovRepository(),
//         userLovRepo: UserLovRepository(),
//       )
//       // ..add(LoadRoleLovEvent())
//       // ..add(LoadUserLovEvent())
//       ,
//       child: const User(),
//     );
//   }
// }

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LOVs"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.push(Get_All_User);
            },
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            roleLov(),
            const Divider(color: Colors.black, height: 12),
            userLov(),
            const Divider(color: Colors.black, height: 12),
            findUserById(),
            const Divider(color: Colors.black, height: 12),
            const LogoutButton(),

            //
            //
            // Expanded(
            // flex: 1,
            // child: BlocBuilder<UserBloc, UserState>(
            //   builder: (context, state) {
            //     // if (state is InitailState) {
            //     //   context.read<UserBloc>().add(LoadRoleLovEvent());
            //     //   // context.read<UserBloc>().add(LoadUserLovEvent());
            //     // }
            //     if (state is RoleLovLoadingState) {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }  if (state is RoleLovLoadedState) {
            //       // 1st lov
            //       print("Length roles: ${state.listOfRoles.length}");
            //       context.read<UserBloc>().add(LoadRoleLovEvent());
            //       return
            //           // Column(
            //           //   children: [
            //           //     Expanded(
            //           //       child:
            //           ListView.builder(
            //         itemCount: state.listOfRoles.length,
            //         itemBuilder: (context, index) {
            //           return Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: ListTile(
            //               tileColor: Colors.deepPurpleAccent,
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(8),
            //               ),
            //               title: Text(
            //                 state.listOfRoles[index].name.en!,
            //               ),
            //               subtitle: Text(
            //                 ("Active: ${state.listOfRoles[index].active.toString()}"),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //       //     ),
            //       //   ],
            //       // );
            //     }  if (state is RoleLovErrorState) {
            //       // context.read<UserBloc>().add(LoadRoleLovEvent());
            //       // context.read<UserBloc>().add(LoadUserLovEvent());
            //       return const Center(
            //         child: Text("Error"),
            //       );
            //     }  {
            //       return const Center(
            //         child: Text("No State",
            //             style: TextStyle(color: Colors.black)),
            //       );
            //     }
            //     return const SizedBox();
            //   },
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}

Widget roleLov() {
  return BlocProvider(
      create: (context) => UserBloc(
            roleLovRepo: RoleLovRepository(),
            userLovRepo: UserLovRepository(),
            findUserByIdRepo: FindUserByIdRepository(),
          ),
      child: Expanded(
        flex: 1,
        child: BlocBuilder<UserBloc, UserState>(
          // buildWhen: (previous, current) => current != previous,
          // buildWhen: (previous, current) => State is UserLovLoadedState,

          builder: (context, state) {
            if (state is InitailState) {
              context.read<UserBloc>().add(LoadRoleLovEvent());
              // context.read<UserBloc>().add(LoadUserLovEvent());
            }
            if (state is RoleLovLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is RoleLovLoadedState) {
              // 2nd lov
              print("Length Roles api 1: ${state.listOfRoles.length}");
              print("Roles: ${state.listOfRoles}");

              List<RoleLovResponse> roles = state.listOfRoles;

              return DropdownButtonFormField(
                menuMaxHeight: 400.0,
                // isExpanded: true,
                // itemHeight: 100.0,
                onChanged: (value) {},
                decoration: const InputDecoration(hintText: "Select Role"),
                items:
                    roles.map<DropdownMenuItem<String>>((RoleLovResponse user) {
                  return DropdownMenuItem<String>(
                    value: user.name.en,
                    child: Text(user.name.en!),
                  );
                }).toList(),
              );

              // ListView.builder(
              //   itemCount: state.listOfUsers.length,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: ListTile(
              //         tileColor: Colors.deepPurpleAccent,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         title: Text(
              //           state.listOfUsers[index].fullName.en!,
              //         ),
              //         subtitle: Text(
              //           ("ID: ${state.listOfUsers[index].id.toString()}"),
              //         ),
              //       ),
              //     );
              //   },
              // );
            }
            if (state is RoleLovErrorState) {
              // context.read<UserBloc>().add(LoadRoleLovEvent());
              // context.read<UserBloc>().add(LoadUserLovEvent());
              return const Center(child: Text("Error"));
            }
            // {
            //   return const Center(child: Text("No state Role LOV"));
            // }
            // return const SizedBox();
            return const Center(
              child: Text("No state Role LOV"),
            );
          },
        ),
      ));
}

Widget userLov() {
  return BlocProvider(
      create: (context) => UserBloc(
            roleLovRepo: RoleLovRepository(),
            userLovRepo: UserLovRepository(),
            findUserByIdRepo: FindUserByIdRepository(),
          ),
      child: Expanded(
        flex: 1,
        child: BlocBuilder<UserBloc, UserState>(
          buildWhen: (previous, current) =>
              current is! FindUserByIdLoadingState &&
              current is! FindUserByIdLoadedState &&
              current is! FindUserByIdErrorState,
          builder: (context, state) {
            if (state is InitailState) {
              // context.read<UserBloc>().add(LoadRoleLovEvent());
              context.read<UserBloc>().add(LoadUserLovEvent());
            }
            if (state is UserLovLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UserLovLoadedState) {
              // 2nd lov
              print("Length User api 2: ${state.listOfUsers.length}");
              print("Roles: ${state.listOfUsers}");

              List<UserLovResponse> users = state.listOfUsers;

              return DropdownButtonFormField(
                menuMaxHeight: 400.0,
                // isExpanded: true,
                // itemHeight: 100.0,
                onChanged: (value) {
                  int selectedUserID = 0;

                  var data = users.firstWhere((element) =>
                      "${element.fullName.en}${element.id}" ==
                      value.toString());
                  selectedUserID = data.id;
                  print(selectedUserID);

                  context
                      .read<UserBloc>()
                      .add(FindUserByIdEvent(userId: selectedUserID));
                },
                decoration: const InputDecoration(hintText: "Select User"),
                items:
                    users.map<DropdownMenuItem<String>>((UserLovResponse user) {
                  return DropdownMenuItem<String>(
                    value: "${user.fullName.en}${user.id}",
                    child: Text(
                      removeDigit(user.fullName.en.toString()),
                    ),
                  );
                }).toList(),
              );

              // ListView.builder(
              //   itemCount: state.listOfUsers.length,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: ListTile(
              //         tileColor: Colors.deepPurpleAccent,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         title: Text(
              //           state.listOfUsers[index].fullName.en!,
              //         ),
              //         subtitle: Text(
              //           ("ID: ${state.listOfUsers[index].id.toString()}"),
              //         ),
              //       ),
              //     );
              //   },
              // );
            }
            if (state is UserLovErrorState) {
              // context.read<UserBloc>().add(LoadRoleLovEvent());
              // context.read<UserBloc>().add(LoadUserLovEvent());
              return const Center(child: Text("Error"));
            }
            // {
            //   return const Center(child: Text("No state User LOV"));
            // }
            // return const SizedBox();
            return const Center(
              child: Text("No state User LOV"),
            );
          },
        ),
      ));
}

removeDigit(final String s) {
  return s.replaceAll(RegExp(r"[0-9]+"), "");
}

Widget findUserById() {
  return BlocProvider(
      create: (context) => UserBloc(
            roleLovRepo: RoleLovRepository(),
            userLovRepo: UserLovRepository(),
            findUserByIdRepo: FindUserByIdRepository(),
          ),
      child: Expanded(
        flex: 1,
        child: BlocBuilder<UserBloc, UserState>(
          // buildWhen: (previous, current) => State is UserLovLoadedState,
          builder: (context, state) {
            if (state is InitailState) {
              return const Center(
                child: Text("No User Selected!"),
              );
            }
            if (state is FindUserByIdLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FindUserByIdLoadedState) {
              Card(
                color: Colors.tealAccent[100],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(60),
                        ),
                        child: Image.network(
                          IMG_BASE_URL + state.userDetails.profilePic!,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const CircularProgressIndicator();
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.account_circle_outlined,
                            size: 90,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.userDetails.fullName!.en!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(state.userDetails.email!),
                          Text(state.userDetails.address!.en!),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        state.userDetails.status!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is FindUserByIdErrorState) {
              return const Center(child: Text("Error"));
            }
            return const Center(
              child: Text("No state User detail"),
            );
          },
        ),
      ));
}
