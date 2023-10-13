import 'package:project_cleanarchiteture/Features/auth/Login/Data/datasource/LoginRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Domain/params/UserLoginInput.dart';
import 'package:test/test.dart';

void main() {
  late LoginRemoteDatasource loginRepository;

  setUp(() {
    loginRepository = LoginRemoteDatasourceImpl();
  });

  test('Successfully logged in user', () async {
    expect(
      await loginRepository.userLogin(
          input: UserLoginInput(
        deviceId: "qwertyuiop",
        email: "test@yopmail.com",
        loginIp: "124.29.228.51",
        password: "1234567890",
      )),
      {
        '__typename': 'Mutation',
        'loginUser': {
          '__typename': 'AuthPayload',
          'id': 25,
          'fullName': {'__typename': 'enAr', 'ar': 'نفنفق ', 'en': 'test'},
          'email': 'test@yopmail.com',
          'profilePic': 'assets/profile/profile-1692688082453.jpg',
          'role': {
            '__typename': 'Role',
            'id': 1,
            'name': {'__typename': 'enAr', 'en': 'Admin', 'ar': 'مسؤل'}
          },
          'token':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjUsIm1haWwiOiJ0ZXN0QHlvcG1haWwuY29tIiwiaWF0IjoxNjk3MDIxOTM5LCJleHAiOjE3MjgxMjU5Mzl9.cMmJvzdDOSjl5WX_IjbP1BuRVB5gA_ktiSSY169i1q0'
        }
      },
    );
  });
}
