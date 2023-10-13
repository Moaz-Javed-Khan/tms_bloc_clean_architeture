import 'package:project_cleanarchiteture/Features/CRUD/repo/roles_lov_repository.dart';
import 'package:test/test.dart';

void main() {
  late RoleLovRepository roleLovRepository;

  setUp(() {
    roleLovRepository = RoleLovRepository();
  });

  test('Successfully got role LOV', () async {
    expect(
      await roleLovRepository.roleLov(
        token:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjUsIm1haWwiOiJ0ZXN0QHlvcG1haWwuY29tIiwiaWF0IjoxNjk3MDIxOTM5LCJleHAiOjE3MjgxMjU5Mzl9.cMmJvzdDOSjl5WX_IjbP1BuRVB5gA_ktiSSY169i1q0',
      ),
      {
        '__typename': 'Query',
        'getAllRoleslov': [
          {
            '__typename': 'Role',
            'active': true,
            'id': 1,
            'name': {'__typename': 'enAr', 'ar': 'مسؤل', 'en': 'Admin'}
          },
          {
            '__typename': 'Role',
            'active': true,
            'id': 2,
            'name': {'__typename': 'enAr', 'ar': 'مستخدم', 'en': 'User'}
          },
          {
            '__typename': 'Role',
            'active': true,
            'id': 3,
            'name': {
              '__typename': 'enAr',
              'ar': 'مشرف فائق',
              'en': 'Super Admin'
            }
          },
          {
            '__typename': 'Role',
            'active': true,
            'id': 5,
            'name': {'__typename': 'enAr', 'ar': 'تست', 'en': 'testing'}
          },
          {
            '__typename': 'Role',
            'active': true,
            'id': 29,
            'name': {'__typename': 'enAr', 'ar': 'تت', 'en': 'aa'}
          }
        ]
      },
    );
  });
}
