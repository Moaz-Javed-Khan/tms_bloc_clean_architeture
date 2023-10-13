import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';

class FindUserByIdRepository extends BaseRepository {
  Future findUserById({
    required int userId,
    required String token,
  }) async {
    try {
      GraphQLClient client = graphqlConfig.clientToQuery(token);
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(
            """
              query GetUserById(\$getUserByIdId: Int!) {
                getUserById(id: \$getUserByIdId) {
                  active
                  address {
                    ar
                    en
                  }
                  deviceId
                  email
                  fullName {
                    ar
                    en
                  }
                  gender
                  id
                  phoneNumber
                  profilePic
                  role {
                    id
                    name {
                      ar
                      en
                    }
                  }
                  status
                }
              }
              """,
          ),
          variables: {
            "getUserByIdId": userId,
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
      throw Exception(error).toString();
    }
  }
}
