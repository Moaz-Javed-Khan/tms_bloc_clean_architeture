import 'package:project_cleanarchiteture/Core/BaseRepository.dart';

abstract class CreateNewPasswordRepository extends BaseRepository {
  userCreateNewPassword(
    String newPassword,
    String email,
    String otp,
  );
}
