import 'package:graphql/client.dart';
import 'package:reference_v2/seed/data/gql/graphql.dart';
import 'package:reference_v2/settings.dart';

/// @module gql

class GraphQL extends GraphQLCore {

  late GraphQLClient _client;
  late Link _link;

  GraphQL() {

    String token = ""; // TODO make token module

    final _httpLink = HttpLink(GRAPH_URL);
    final _authLink = AuthLink(
        getToken: () async => "Token $token"
    );

    _link = _authLink.concat(_httpLink);
    _link = _httpLink;
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );

  }

  /// Return a GraphQL query response as Map<dynamic, dynamic>
  /// @param [gqlQuery] GraphQL Query
  /// @param [paramQuery] query param (sql alike)
  /// @param [options] extra query options
  /// @example
  /// var response = gql.query("""
  /// {
  ///   players {
  ///     name,
  ///     age
  ///   }
  /// }""", extraParams: "name=cristiano")
  dynamic query(String gqlQuery, {String? paramQuery, dynamic extraParams}) async {

    var normalizedQuery = normalizeQuery(gqlQuery);
    var queryName = getHeaderNames(gqlQuery)[0];

    // Build query
    var params = "";

    if(paramQuery != null) params += "query: \"$paramQuery\",";

    if(extraParams != null) {
      if(extraParams["orderBy"] != null) params += "orderBy: \"${extraParams["orderBY"]}\",";
      if(extraParams["limit"] != null) params += "limit: ${extraParams["start"]},";
      if(extraParams["pageNum"] != null) params += "pageNum: ${extraParams["pageNum"]},";
      if(extraParams["pageSize"] != null) params += "pageSize: ${extraParams["pageSize"]},";
    }

    if(params.endsWith(",")) params = params.substring(0, params.length - 1);

    var wrapper = "$queryName${params != "" ? "(" + params + ")" : ""}";
    var query = normalizedQuery.replaceFirst(queryName!, wrapper);

    // Execute query & catch errors
    return await manageResponse(
      _client.query(
        QueryOptions(
          document: gql(query),
          fetchPolicy: FetchPolicy.networkOnly
        )
      )
    );

  }

  /// Return a GraphQL query response as Map<dynamic, dynamic> with pagination
  /// @param [gqlQuery] GraphQL Query
  /// @param [pageNum] page number
  /// @param [pageSize] number of objects per page
  /// @param [paramQuery] query param (sql alike)
  /// @example
  /// var response = gql.pagination("""
  /// {
  ///   playerPagination {
  ///     totalPages
  ///     players {
  ///       id
  ///     }
  ///   }
  /// }""", 1, 15, paramQuery: "position=mainStriker")
  dynamic pagination(String gqlQuery, int pageNum, int pageSize, {String? paramQuery}) async => await query(
      gqlQuery,
      paramQuery: paramQuery,
      extraParams: {
        "pageNum": pageNum,
        "pageSize": pageSize
      }
    );

  /// Return a GraphQL query count response as Map<dynamic, dynamic>
  /// @param [modelName] GraphQL model name
  /// @param [paramQuery] query param (sql alike)
  /// @example
  /// var response = gql.count("player", paramQuery: "position:mainStriker")
  dynamic count(String modelName, {String? paramQuery}) async {
    var gqlQuery = """
    {
      ${modelName}Count {
        count
      }
    }
    """;
    return await query(gqlQuery, paramQuery: paramQuery);
  }

  /// Return a GraphQL detail query (single object)
  /// @param [gqlQuery] GraphQL query
  /// @param [id] identifier of the object
  /// @example
  /// var response = gql.detail("""
  /// {
  ///   playerPagination {
  ///     totalPages
  ///     players {
  ///       id
  ///     }
  ///   }
  /// }""", 1)
  dynamic detail(String gqlQuery, int id) async {

    var normalizedQuery = normalizeQuery(gqlQuery);
    var queryName = getHeaderNames(normalizedQuery)[0];

    // Build query
    var wrapper = "${queryName}(id: $id)";
    var query = normalizedQuery.replaceAll(queryName!, wrapper);

    //  Execute query
    return await manageResponse(
      _client.query(
        QueryOptions(
          document: gql(query),
          fetchPolicy: FetchPolicy.networkOnly
        )
      )
    );

  }

  /// Return a GraphQL response after execute a save mutation
  /// @param [gqlQuery] GraphQL query
  /// @param [variables] object values
  /// @example
  /// var response = gql.save(SAVE_PLAYER, variables: {"name": "cristiano"})
  dynamic save(String gqlQuery, {dynamic variables}) async {
    return await manageResponse(
      _client.mutate(
        MutationOptions(
          document: gql(gqlQuery),
          variables: variables,
          fetchPolicy: FetchPolicy.networkOnly
        )
      )
    );
  }

  /// Return a GraphQL response after execute a set mutation
  /// @param [gqlQuery] GraphQL query
  /// @param [variables] object values
  /// @example
  /// var response = gql.save(SAVE_PLAYER, variables: {"id": 1, "name": "cristiano ronaldo"})
  dynamic set(String gqlQuery, {dynamic variables}) async {
    return await manageResponse(
      _client.mutate(
        MutationOptions(
          document: gql(gqlQuery),
          variables: variables,
          fetchPolicy: FetchPolicy.networkOnly
        )
      )
    );
  }

  /// Return a GraphQL response after execute a delete mutation
  /// @param [gqlQuery] GraphQL query
  /// @param [variables] object values
  /// @example
  /// var response = gql.save(SAVE_PLAYER, variables: {"id": 1})
  dynamic delete(String gqlQuery, {dynamic variables}) async {
    return await manageResponse(
      _client.mutate(
        MutationOptions(
          document: gql(gqlQuery),
          variables: variables,
          fetchPolicy: FetchPolicy.networkOnly
        )
      )
    );
  }

}