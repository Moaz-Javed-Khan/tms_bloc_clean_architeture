import 'package:project_cleanarchiteture/Core/failures.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/data/datasources/CreateNewPasswordRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/domain/repositories/ForgetPasswordRepository.dart';

class CreateNewPasswordRepositoryImple extends CreateNewPasswordRepository {
  final CreateNewPasswordRemoteDatasource remotedatasources;

  CreateNewPasswordRepositoryImple({required this.remotedatasources});

  @override
  userCreateNewPassword(
    String newPassword,
    String email,
    String otp,
  ) async {
    try {
      final remoteData = await remotedatasources.userCreateNewPassword(
        password: newPassword,
        email: email,
        otp: otp,
      );

      return remoteData;
    } catch (error) {
      throw ServerFailure(message: error.toString());
    }
  }
}
