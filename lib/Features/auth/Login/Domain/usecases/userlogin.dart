import 'package:project_cleanarchiteture/Features/auth/Login/Domain/params/UserLoginInput.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Domain/repositories/LoginRepository.dart';

class userloginUsecase {
  final LoginRepository repository;

  userloginUsecase({required this.repository});
  execute(UserLoginInput userLogin) async {
    return repository.userlogin(userLogin);
  }
}
