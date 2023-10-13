import 'package:project_cleanarchiteture/Core/failures.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Data/datasources/SignupRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/params/UserSignupInput.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/repositories/SignupRepository.dart';

class SignupRepositoryImple extends SignupRepository {
  final SignupRemoteDatasource remotedatasources;

  SignupRepositoryImple({required this.remotedatasources});

  @override
  userSignup(UserSignupInput input) async {
    try {
      final remoteData = await remotedatasources.userSignup(input: input);

      // final remoteData =
      //     await serviceLocator<SignupRemoteDatasource>().userSignup(input: input);

      print("Repo Result: $remoteData");

      return remoteData;
    } catch (error) {
      throw ServerFailure(message: error.toString());
    }
  }
}
