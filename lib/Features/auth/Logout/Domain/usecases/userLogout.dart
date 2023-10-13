import 'package:project_cleanarchiteture/Features/auth/Logout/Domain/repositories/LogoutRepository.dart';

class UserLogoutUsecase {
  final LogoutRepository repository;

  UserLogoutUsecase({required this.repository});
  execute(
    String deviceId,
    String token,
  ) async {
    return repository.userLogout(
      deviceId,
      token,
    );
  }
}
