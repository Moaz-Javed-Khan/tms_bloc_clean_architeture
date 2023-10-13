import 'package:flutter/material.dart';
import 'package:project_cleanarchiteture/Utils/Extensions.dart';
import 'package:project_cleanarchiteture/Utils/localData.dart';
import 'package:test/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('Successfully got local data', () async {
    LocalData localData = LocalData();
    // expect(await localData.getUserinfo(USER_INFO), null);
  });
}
