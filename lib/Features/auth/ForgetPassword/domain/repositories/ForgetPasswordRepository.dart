import 'package:project_cleanarchiteture/Core/BaseRepository.dart';

abstract class ForgetPasswordRepository extends BaseRepository {
  userForgetPassword(String email);
}
