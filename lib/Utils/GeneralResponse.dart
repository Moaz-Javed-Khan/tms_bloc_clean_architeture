import 'package:project_cleanarchiteture/Core/CustomError.dart';

class GeneralResponse<T> {
  late List<CustomError>? error;
  late T? data;

  GeneralResponse(this.error, this.data);

  GeneralResponse.fromJson(Map<String, dynamic> json) {
    error = json["error"];
    data = json["data"];
  }
}
