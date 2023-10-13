import 'dart:convert';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Domain/params/UserLoginInput.dart';

abstract class LoginRemoteDatasource extends BaseRepository {
  userLogin({required UserLoginInput input});
}

class LoginRemoteDatasourceImpl extends LoginRemoteDatasource {
  // final http.Client client;
  // final BASE_URL = "http://192.168.0.33:5000/";
  // final GraphQLClient graphQLClient;
  // LoginRemoteDatasourceImpl({required this.graphQLClient});
  // @override
  // Future<LoginAdmin> fetchDataFromApi() async {
  //   try {
  //     final response = await client.get(Uri.parse(BASE_URL), headers: {
  //       HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  //     });
  //     if (response.statusCode == 200) {
  //       final results = LoginAdmin.fromJson(jsonDecode(response.body));
  //       return results;
  //       print(results);
  //     } else
  //       throw Exception("failed");
  //   }
  //   catch (e) {
  //     if (e is ServerException) rethrow;
  //     throw e.toString();
  //   }
  //
  // }

  @override
  userLogin({required UserLoginInput input}) async {
    try {
      GraphQLClient client = graphqlConfig.clientToQuery(null);
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
            mutation LoginUser(\$input: loginUserInput!) {
              loginUser(input: \$input) {
                id
                fullName {
                  ar
                  en
                }
              
                email
                profilePic
                role {
                  id
                  name {
                    en
                    ar
                  }
                }
                token
              }
            }
            """,
          ),
          variables: {
            "input": {
              "email": input.email,
              "password": input.password,
              "deviceId": input.deviceId,
              "loginIp": input.loginIp,
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(Code.fromJson(
                jsonDecode(result.exception!.graphqlErrors.first.message))
            .message);
      } else {
        return result.data;

        //LoginAdmin.fromJson(jsonDecode(data));
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
