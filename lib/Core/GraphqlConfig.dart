import 'package:graphql_flutter/graphql_flutter.dart';

import '../Utils/Extensions.dart';

class GraphqlConfig {
  Link? main_link;
  HttpLink httpLink = HttpLink(
    "${BASE_URL}graphql",
  );

  GraphQLClient clientToQuery(String? token) {
    if (token != null) {
      final AuthLink authLink = AuthLink(
        getToken: () => '${token}',
      );

      main_link = authLink.concat(httpLink);
    } else {
      main_link = httpLink;
    }

    return GraphQLClient(
      cache: GraphQLCache(),
      link: main_link!!,
    );
  }
}
