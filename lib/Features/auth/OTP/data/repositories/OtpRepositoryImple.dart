import 'package:project_cleanarchiteture/Core/failures.dart';
import 'package:project_cleanarchiteture/Features/auth/OTP/domain/repositories/OtpRepository.dart';
import 'package:project_cleanarchiteture/Features/auth/Otp/data/datasources/OtpRemoteDatasource.dart';

class OtpRepositoryImple extends OtpRepository {
  final OtpRemoteDatasource remotedatasources;

  OtpRepositoryImple({required this.remotedatasources});

  @override
  userOtp({
    required String otp,
    required String email,
    String? password,
  }) async {
    try {
      final remoteData = await remotedatasources.userOtp(
        email: email,
        otp: otp,
      );

      print("Repo Result: $remoteData");

      return remoteData;
    } catch (error) {
      throw ServerFailure(message: error.toString());
    }
  }
}
