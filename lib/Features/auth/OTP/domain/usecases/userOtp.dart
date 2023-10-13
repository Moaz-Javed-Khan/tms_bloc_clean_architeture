import 'package:project_cleanarchiteture/Features/auth/OTP/domain/repositories/OtpRepository.dart';

class userOtpUsecase {
  final OtpRepository repository;

  userOtpUsecase({required this.repository});
  execute({
    required String otp,
    required String email,
    String? password,
  }) async {
    return repository.userOtp(
      email: email,
      otp: otp,
    );
  }
}
