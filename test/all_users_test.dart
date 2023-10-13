import 'package:project_cleanarchiteture/Features/auth/Login/Domain/entities/Name.dart';
import 'package:project_cleanarchiteture/Features/pagination/repo/GetAllUsersRequestModel.dart';
import 'package:project_cleanarchiteture/Features/pagination/repo/get_all_user_repository.dart';
import 'package:test/test.dart';

void main() {
  late GetAllUsersRepository getAlluserRepository;

  setUp(() {
    getAlluserRepository = GetAllUsersRepository();
  });

  test('Successfully got all users', () async {
    expect(
        await getAlluserRepository.getAllUsers(
          token:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjUsIm1haWwiOiJ0ZXN0QHlvcG1haWwuY29tIiwiaWF0IjoxNjk3MDIxOTM5LCJleHAiOjE3MjgxMjU5Mzl9.cMmJvzdDOSjl5WX_IjbP1BuRVB5gA_ktiSSY169i1q0',
          input: GetAllUsersRequest(
            active: true,
            pageStart: 0,
            roleId: null,
            status: "Approved",
            fullName: Name(
              ar: "ar",
              en: "en",
            ),
          ),
        ),
        {
          '__typename': 'Query',
          'getAllUser': {
            '__typename': 'paginateUser',
            'limit': 10,
            'pageStart': 10,
            'totalCount': 0,
            'users': []
          }
        });
  });
}
