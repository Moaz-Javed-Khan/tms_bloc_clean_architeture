import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Domain/params/UserLoginInput.dart';

abstract class LoginRepository extends BaseRepository {
  userlogin(UserLoginInput userLogin);
}
