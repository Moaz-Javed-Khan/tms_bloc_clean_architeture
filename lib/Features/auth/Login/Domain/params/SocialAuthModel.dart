class GoogleSignInAccountModel {
  String displayName;
  String email;
  String id;
  String photoUrl;
  String serverAuthCode;

  GoogleSignInAccountModel({
    required this.displayName,
    required this.email,
    required this.id,
    required this.photoUrl,
    required this.serverAuthCode,
  });

  factory GoogleSignInAccountModel.fromJson(Map<String, dynamic> json) =>
      GoogleSignInAccountModel(
        displayName: json["displayName"],
        email: json["email"],
        id: json["id"],
        photoUrl: json["photoUrl"],
        serverAuthCode: json["serverAuthCode"],
      );

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "email": email,
        "id": id,
        "photoUrl": photoUrl,
        "serverAuthCode": serverAuthCode,
      };
}
