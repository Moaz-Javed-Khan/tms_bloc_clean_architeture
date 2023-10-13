import 'dart:convert';

import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/entities/AddressModel.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/entities/Name.dart';

class UserSignupInput {
  UserSignupInput({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
  });

  String? deviceId;
  String? email;
  String? password;
  String? phoneNumber;
  Name? fullName;
  Address? address;

  factory UserSignupInput.fromJson(Map<String, dynamic> json) =>
      UserSignupInput(
        deviceId: json["deviceId"],
        email: json["email"],
        password: json["password"],
        fullName: Name.fromJson(json["fullName"]),
        address: Address.fromJson(json["address"]),
        phoneNumber: json['phoneNumber'],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "email": email,
        "password": password,
        "fullName": fullName?.toJson(),
        "address": address?.toJson(),
        "phoneNumber": phoneNumber,
      };

  UserSignupInput createUserInputFromJson(String str) =>
      UserSignupInput.fromJson(json.decode(str));

  String userSignupToJson(UserSignupInput data) => json.encode(data.toJson());
}
