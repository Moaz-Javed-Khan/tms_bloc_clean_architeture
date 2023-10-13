import 'package:project_cleanarchiteture/Core/failures.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/Domain/repositories/ForgetPasswordRepository.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/data/datasources/ForgetPasswordRemoteDatasource.dart';

class ForgetPasswordRepositoryImple extends ForgetPasswordRepository {
  final ForgetPasswordRemoteDatasource remotedatasources;

  ForgetPasswordRepositoryImple({required this.remotedatasources});

  @override
  userForgetPassword(String email) async {
    try {
      final remoteData =
          await remotedatasources.userForgetPassword(email: email);

      return remoteData;
    } catch (error) {
      throw ServerFailure(message: error.toString());
    }
  }
}
