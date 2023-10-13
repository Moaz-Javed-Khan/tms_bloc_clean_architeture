import 'dart:convert';
import 'Name.dart';
import 'Role.dart';

AdminSignInReponse signInResponseFromJson(String str) =>
    AdminSignInReponse.fromJson(json.decode(str));

String signInResponseToJson(AdminSignInReponse data) =>
    json.encode(data.toJson());

class AdminSignInReponse {
  Data data;

  AdminSignInReponse({
    required this.data,
  });

  factory AdminSignInReponse.fromJson(Map<String, dynamic> json) =>
      AdminSignInReponse(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  LoginAdmin loginAdmin;

  Data({
    required this.loginAdmin,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        loginAdmin: LoginAdmin.fromJson(json["loginAdmin"]),
      );

  Map<String, dynamic> toJson() => {
        "loginAdmin": loginAdmin.toJson(),
      };
}

class LoginAdmin {
  int id;
  String token;
  Name fullName;
  String email;
  Role role;
  String profilePic;

  LoginAdmin({
    required this.id,
    required this.token,
    required this.fullName,
    required this.email,
    required this.role,
    required this.profilePic,
  });

  factory LoginAdmin.fromJson(Map<String, dynamic> json) => LoginAdmin(
        id: json["id"],
        token: json["token"],
        fullName: Name.fromJson(json["fullName"]),
        email: json["email"],
        role: Role.fromJson(json["role"]),
        profilePic: json["profilePic"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "fullName": fullName.toJson(),
        "email": email,
        "role": role.toJson(),
        "profilePic": profilePic,
      };
}
