import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Domain/params/UserSignupInput.dart';

abstract class SignupRemoteDatasource extends BaseRepository {
  userSignup({required UserSignupInput input});
}

class SignupRemoteDatasourceImpl extends SignupRemoteDatasource {
  @override
  userSignup({required UserSignupInput input}) async {
    try {
      GraphQLClient client = graphqlConfig.clientToQuery(null);
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
              mutation CreateUser(\$input: createUserInput!) {
                createUser(input: \$input) {
                  message
                }
              }
            """,
          ),
          variables: {
            "input": {
              "address": input.address!,
              "deviceId": input.deviceId,
              "email": input.email,
              "fullName": input.fullName!,
              "password": input.password,
              "phoneNumber": input.phoneNumber
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(Code.fromJson(
          jsonDecode(result.exception!.graphqlErrors.first.message),
        ).message);
      } else {
        // final data = result.data!["createUser"];
        return result.data;
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
