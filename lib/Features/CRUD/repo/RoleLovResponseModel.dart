import 'dart:convert';

class RoleLovResponse {
  RoleLovResponse({
    required this.active,
    required this.id,
    required this.name,
  });

  bool? active;
  int id;
  Name name;

  factory RoleLovResponse.fromJson(Map<String, dynamic> json) =>
      RoleLovResponse(
        active: json["active"],
        id: json["id"],
        name: Name.fromJson(json["name"]),
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "id": id,
        "name": name.toJson(),
      };

  // static List<UserLovResponse> listFromJson(List<dynamic> jsonList) {
  //   List<UserLovResponse> userList = [];
  //   for (dynamic json in jsonList) {
  //     userList.add(UserLovResponse.fromJson(json));
  //   }
  //   return userList;
  // }

  RoleLovResponse roleLovRequestFromJson(String str) =>
      RoleLovResponse.fromJson(json.decode(str));

  String roleLovRequestToJson(RoleLovResponse data) =>
      json.encode(data.toJson());
}

class Name {
  String? ar;
  String? en;

  Name({
    required this.ar,
    required this.en,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        ar: json["ar"] as String,
        en: json["en"] as String,
      );

  Map<String, dynamic> toJson() => {
        "ar": ar,
        "en": en,
      };
}
