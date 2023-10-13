import 'package:project_cleanarchiteture/Core/failures.dart';
import 'package:project_cleanarchiteture/Features/auth/Logout/Data/datasources/LogoutRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Logout/Domain/repositories/LogoutRepository.dart';

class LogoutRepositoryImple extends LogoutRepository {
  final LogoutRemoteDatasource remotedatasources;

  LogoutRepositoryImple({required this.remotedatasources});

  @override
  userLogout(
    String deviceId,
    String token,
  ) async {
    try {
      final remoteData = await remotedatasources.userLogout(
        deviceId: deviceId,
        token: token,
      );

      // final remoteData =
      //     await serviceLocator<LogoutRemoteDatasource>().userLogout(input: input);

      return remoteData;
    } catch (error) {
      throw ServerFailure(message: error.toString());
    }
  }
}
