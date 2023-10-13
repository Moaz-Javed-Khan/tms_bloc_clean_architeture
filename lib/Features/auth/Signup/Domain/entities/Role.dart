import 'Name.dart';

class Role {
  Name name;
  int id;
  bool? active;

  Role({required this.name, required this.active, required this.id});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
      name: Name.fromJson(json["name"]),
      active: json["active"] ?? false,
      id: json['id']);

  Map<String, dynamic> toJson() => {
        "name": name.toJson(),
        "active": active,
        "id": id,
      };
}
