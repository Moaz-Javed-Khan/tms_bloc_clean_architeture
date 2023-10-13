import 'dart:convert';

class UserLoginInput {
  UserLoginInput({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.loginIp,
  });

  String? deviceId;
  String? email;
  String? password;
  String? loginIp;

  factory UserLoginInput.fromJson(Map<String, dynamic> json) => UserLoginInput(
        deviceId: json["deviceId"],
        email: json["email"],
        password: json["password"],
        loginIp: json['loginIp'],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "email": email,
        "password": password,
        "loginIp": loginIp,
      };

  UserLoginInput createUserInputFromJson(String str) =>
      UserLoginInput.fromJson(json.decode(str));

  String userLoginToJson(UserLoginInput data) => json.encode(data.toJson());
}
