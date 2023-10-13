import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';

class RoleLovRepository extends BaseRepository {
  Future roleLov({required String token}) async {
    try {
      GraphQLClient client = graphqlConfig.clientToQuery(token);
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(
            """
            query GetAllRoleslov {
                getAllRoleslov {
                  active
                  id
                  name {
                    ar
                    en
                  }
                }
              }
              """,
          ),
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
      throw Exception(error).toString();
    }
  }
}
