import 'dart:convert';

import 'package:project_cleanarchiteture/Features/CRUD/repo/UserModel.dart';

class GetAllUsersResponse {
  GetAllUsersResponse({
    required this.limit,
    required this.pageStart,
    required this.totalCount,
    required this.users,
  });

  int? limit;
  int? pageStart;
  int? totalCount;
  List<User>? users;

  factory GetAllUsersResponse.fromJson(Map<String, dynamic> json) =>
      GetAllUsersResponse(
        limit: json["limit"] as int,
        pageStart: json["pageStart"] as int,
        totalCount: json["totalCount"] as int,
        users: (json["users"] as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "pageStart": pageStart,
        "totalCount": totalCount,
        "users": users!.map((e) {
          return e.toJson();
        }).toList(),
      };

  User getAllUsersResponseFromJson(String str) =>
      User.fromJson(json.decode(str));

  String getAllUsersResponseToJson(User data) => json.encode(data.toJson());
}
