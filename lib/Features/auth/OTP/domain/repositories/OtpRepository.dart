import 'package:project_cleanarchiteture/Core/BaseRepository.dart';

abstract class OtpRepository extends BaseRepository {
  userOtp({
    required String otp,
    required String email,
    String? password,
  });
}
