import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/Domain/repositories/ForgetPasswordRepository.dart';

class userForgetPasswordUsecase {
  final ForgetPasswordRepository repository;

  userForgetPasswordUsecase({required this.repository});
  execute(String email) async {
    return repository.userForgetPassword(email);
  }
}
