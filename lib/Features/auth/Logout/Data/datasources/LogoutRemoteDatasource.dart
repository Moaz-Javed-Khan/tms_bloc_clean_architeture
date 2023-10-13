import 'dart:convert';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';

abstract class LogoutRemoteDatasource extends BaseRepository {
  userLogout({
    required String deviceId,
    required String token,
  });
}

class LogoutRemoteDatasourceImpl extends LogoutRemoteDatasource {
  @override
  userLogout({
    required String deviceId,
    required String token,
  }) async {
    try {
      GraphQLClient client = graphqlConfig.clientToQuery(token);
      QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(
            """
              mutation Logout(\$deviceId: String!) {
                logout(deviceId: \$deviceId) {
                  message
                }
              }
            """,
          ),
          variables: {
            "deviceId": deviceId,
          },
        ),
      );

      if (result.hasException) {
        print("Data in result: ${result.data}");
        throw Exception(
          Code.fromJson(
            jsonDecode(result.exception!.graphqlErrors.first.message),
          ),
        );
      } else {
        print("Data in result: ${result.data}");
        return result.data;
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
