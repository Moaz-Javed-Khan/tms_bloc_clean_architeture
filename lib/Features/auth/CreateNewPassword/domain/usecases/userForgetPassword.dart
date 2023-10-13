import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/domain/repositories/ForgetPasswordRepository.dart';

class UserCreateNewPasswordUsecase {
  final CreateNewPasswordRepository repository;

  UserCreateNewPasswordUsecase({required this.repository});
  execute(
    String newPassword,
    String email,
    String otp,
  ) async {
    return repository.userCreateNewPassword(
      newPassword,
      email,
      otp,
    );
  }
}
