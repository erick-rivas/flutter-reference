import 'package:graphql/client.dart';
import 'datasources/cache.dart';
import 'datasources/gql/gql_core.dart';
import 'package:reference/settings.dart';

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

  /// Execute pending http requests when the phone is offline
  void retryFailedRequests() async {

    var requests = await CacheAPI().getPendingGQLRequests();
    await CacheAPI().clearPendingGQLRequest();

    for(var request in requests["QUERY"])
      await query(request["query"], useCache: true);

    for(var request in requests["SAVE"])
      await save(request["query"], variables: requests["variables"], useCache: true);

    for(var request in requests["SET"])
      await set(request["query"], variables: requests["variables"], useCache: true);

    for(var request in requests["DELETE"])
      await delete(request["query"], variables: requests["variables"], useCache: true);

  }

  /// Return a GraphQL query response as Map<dynamic, dynamic>
  /// @param [gqlQuery] GraphQL Query
  /// @param [paramQuery] query param (sql alike)
  /// @param [options] extra query options
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = gql.query("""
  /// {
  ///   players {
  ///     name,
  ///     age
  ///   }
  /// }""", extraParams: "name=cristiano")
  dynamic query(String gqlQuery, {String? paramQuery, dynamic extraParams, bool? useCache}) async {

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
      ),
      query,
      useCache: useCache,
      method: "QUERY"
    );

  }

  /// Return a GraphQL query response as Map<dynamic, dynamic> with pagination
  /// @param [gqlQuery] GraphQL Query
  /// @param [pageNum] page number
  /// @param [pageSize] number of objects per page
  /// @param [paramQuery] query param (sql alike)
  /// @param [useCache] save in cache the request
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
  dynamic pagination(String gqlQuery, int pageNum, int pageSize, {String? paramQuery,  bool? useCache}) async => await query(
      gqlQuery,
      paramQuery: paramQuery,
      extraParams: {
        "pageNum": pageNum,
        "pageSize": pageSize
      },
    useCache: useCache
    );

  /// Return a GraphQL query count response as Map<dynamic, dynamic>
  /// @param [modelName] GraphQL model name
  /// @param [paramQuery] query param (sql alike)
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = gql.count("player", paramQuery: "position:mainStriker")
  dynamic count(String modelName, {String? paramQuery, bool? useCache}) async {
    var gqlQuery = """
    {
      ${modelName}Count {
        count
      }
    }
    """;
    return await query(gqlQuery, paramQuery: paramQuery, useCache: useCache);
  }

  /// Return a GraphQL detail query (single object)
  /// @param [gqlQuery] GraphQL query
  /// @param [id] identifier of the object
  /// @param [useCache] save in cache the request
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
  dynamic detail(String gqlQuery, int id, bool? useCache) async {

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
      ),
      query,
      useCache: useCache
    );

  }

  /// Return a GraphQL response after execute a save mutation
  /// @param [gqlQuery] GraphQL query
  /// @param [variables] object values
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = gql.save(SAVE_PLAYER, variables: {"name": "cristiano"})
  dynamic save(String query, {dynamic variables, bool? useCache}) async {
    return await manageResponse(
      _client.mutate(
        MutationOptions(
          document: gql(query),
          variables: variables,
          fetchPolicy: FetchPolicy.networkOnly
        )
      ),
      query,
      variables: variables,
      useCache: useCache,
      method: "SAVE"
    );
  }

  /// Return a GraphQL response after execute a set mutation
  /// @param [query] GraphQL query
  /// @param [variables] object values
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = gql.save(SAVE_PLAYER, variables: {"id": 1, "name": "cristiano ronaldo"})
  dynamic set(String query, {dynamic variables, bool? useCache}) async {
    return await manageResponse(
      _client.mutate(
        MutationOptions(
          document: gql(query),
          variables: variables,
          fetchPolicy: FetchPolicy.networkOnly
        )
      ),
      query,
      useCache: useCache,
      variables: variables,
      method: "SET"
    );
  }

  /// Return a GraphQL response after execute a delete mutation
  /// @param [query] GraphQL query
  /// @param [variables] object values
  /// @param [useCache] save in cache the request
  /// @example
  /// var response = gql.save(SAVE_PLAYER, variables: {"id": 1})
  dynamic delete(String query, {dynamic variables, bool? useCache}) async {
    return await manageResponse(
      _client.mutate(
        MutationOptions(
          document: gql(query),
          variables: variables,
          fetchPolicy: FetchPolicy.networkOnly
        )
      ),
      query,
      useCache: useCache,
      variables: variables,
      method: "DELETE"
    );
  }

}