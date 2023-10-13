import 'dart:convert';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:project_cleanarchiteture/Core/BaseRepository.dart';
import 'package:project_cleanarchiteture/Core/CustomError.dart';

abstract class ForgetPasswordRemoteDatasource extends BaseRepository {
  userForgetPassword({required String email});
}

class ForgetPasswordRemoteDatasourceImpl
    extends ForgetPasswordRemoteDatasource {
  @override
  userForgetPassword({required String email}) async {
    try {
      GraphQLClient client = graphqlConfig.clientToQuery(null);
      QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(
            """
            mutation RequestReset(\$email: String!) {
            requestReset(email: \$email) {
            message  
            }
            }
              """,
          ),
          variables: {
            "email": email,
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
