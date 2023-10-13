import 'dart:convert';

CustomError customErrorFromJson(String str) =>
    CustomError.fromJson(json.decode(str));

String customErrorToJson(CustomError data) => json.encode(data.toJson());

class CustomError {
  String message;
  Extensions extensions;

  CustomError({
    required this.message,
    required this.extensions,
  });

  factory CustomError.fromJson(Map<String, dynamic> json) => CustomError(
        message: json["message"],
        extensions: Extensions.fromJson(json["extensions"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "extensions": extensions.toJson(),
      };
}

class Extensions {
  Code code;

  Extensions({
    required this.code,
  });

  factory Extensions.fromJson(Map<String, dynamic> json) => Extensions(
        code: Code.fromJson(json["code"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code.toJson(),
      };
}

class Code {
  String message;
  int statusCode;

  Code({
    required this.message,
    required this.statusCode,
  });

  factory Code.fromJson(Map<String, dynamic> json) => Code(
        message: json["message"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "statusCode": statusCode,
      };
}
