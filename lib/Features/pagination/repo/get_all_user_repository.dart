import 'dart:convert';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';
import 'package:project_cleanarchiteture/Features/pagination/repo/GetAllUsersRequestModel.dart';

class GetAllUsersRepository extends BaseRepository {
  Future getAllUsers({
    required String token,
    required GetAllUsersRequest input,
  }) async {
    try {
      GraphQLClient client = graphqlConfig.clientToQuery(token);
      QueryResult result = await client.query(
        QueryOptions(
            document: gql(
              """
              query GetAllUser(\$input: allUsersInput!) {
                getAllUser(input: \$input) {
                  limit
                  pageStart
                  totalCount
                  users {
                    active
                    email
                    fullName {
                      ar
                      en
                    }
                    id
                    phoneNumber
                    profilePic
                    role {
                      active
                      id
                      name {
                        ar
                        en
                      }
                    }
                    status
                  }
                }
              }
              """,
            ),
            variables: {
              "input": {
                "active": input.active,
                "fullName": (input.fullName != null)
                    ? input.fullName?.toJson()
                    : (null),
                "pageStart": input.pageStart,
                "roleId": input.roleId,
                "status": input.status,
              }
            }),
      );

      if (result.hasException) {
        print("Data in result all Users: ${result.data}");
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
