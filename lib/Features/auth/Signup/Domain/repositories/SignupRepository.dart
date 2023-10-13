import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/params/UserSignupInput.dart';

abstract class SignupRepository extends BaseRepository {
  userSignup(UserSignupInput userSignup);
}
