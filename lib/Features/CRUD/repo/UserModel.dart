import 'dart:convert';

import 'package:project_cleanarchiteture/Features/CRUD/repo/RoleLovResponseModel.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Domain/entities/Role.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/entities/AddressModel.dart';

User UserFromJson(String str) => User.fromJson(json.decode(str));

String UserToJson(User data) => json.encode(data.toJson());

class User {
  bool? active;
  Address? address;
  String? email;
  Name? fullName;
  String? gender;
  int? id;
  String? phoneNumber;
  String? profilePic;
  Role? role;
  String? status;

  User({
    required this.active,
    required this.address,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.id,
    required this.phoneNumber,
    required this.profilePic,
    required this.role,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        active: json["active"] as bool,
        address: Address.fromJson(json["address"]),
        email: json["email"] as String,
        fullName: Name.fromJson(json["fullName"]),
        gender: json["gender"] as String,
        id: json["id"] as int,
        phoneNumber: json["phoneNumber"] as String,
        profilePic: json["profilePic"] as String,
        role: Role.fromJson(json["role"]),
        status: json["status"] as String,
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "address": address?.toJson(),
        "email": email,
        "fullName": fullName?.toJson(),
        "gender": gender,
        "id": id,
        "phoneNumber": phoneNumber,
        "profilePic": profilePic,
        "role": role?.toJson(),
        "status": status,
      };
}

enum Status {
  Pending,
  Approved,
  Reject,
}

final statusValues = EnumValues({
  "Reject": Status.Reject,
  "Pending": Status.Pending,
  "Approved": Status.Approved
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
