import 'package:project_cleanarchiteture/Features/auth/Signup/Data/datasources/SignupRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/entities/AddressModel.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/entities/Name.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/params/UserSignupInput.dart';
import 'package:test/test.dart';

void main() {
  late SignupRemoteDatasource signupRepository;

  setUp(() {
    signupRepository = SignupRemoteDatasourceImpl();
  });

  test('Successfully signed up', () async {
    expect(
        await signupRepository.userSignup(
            input: UserSignupInput(
          deviceId: "qwertyuiop",
          email: "test9565698@yopmail.com",
          address: Address(
            ar: "ar",
            en: "en",
          ),
          fullName: Name(
            ar: "ar",
            en: "en",
          ),
          phoneNumber: "0245874599",
          password: "1234567890",
        )),
        {
          '__typename': 'Mutation',
          'createUser': {
            '__typename': 'showMessage',
            'message': 'Successfully Created'
          }
        });
  });
}
