import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/params/UserSignupInput.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/repositories/SignupRepository.dart';

class UserSignupUsecase {
  final SignupRepository repository;

  UserSignupUsecase({required this.repository});
  execute(UserSignupInput userSignup) async {
    return repository.userSignup(userSignup);
  }
}
