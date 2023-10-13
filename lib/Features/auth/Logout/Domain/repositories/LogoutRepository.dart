import 'package:project_cleanarchiteture/Core/BaseRepository.dart';

abstract class LogoutRepository extends BaseRepository {
  userLogout(
    String deviceId,
    String token,
  );
}
