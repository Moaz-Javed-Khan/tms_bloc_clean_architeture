import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';

class UserLovRepository extends BaseRepository {
  Future userLov({required String token}) async {
    try {
      GraphQLClient client = graphqlConfig.clientToQuery(token);
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(
            """
              query GetAllUserslov {
                getAllUserslov {
                  id
                  email
                  profilePic
                  fullName {
                    en
                    ar
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
