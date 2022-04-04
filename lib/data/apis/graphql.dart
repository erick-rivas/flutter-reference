import 'package:graphql/client.dart';

import '../gql/const.dart';

class GraphQL {

  final String url;
  late GraphQLClient _client;
  late Link _link;

  GraphQL(this.url) {

    String token = ""; // TODO make token module

    final _httpLink = HttpLink(url);
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

  dynamic query(String gqlQuery, {String? paramQuery, dynamic options}) {

    var normalizedQuery = normalizeQuery(gqlQuery);
    var queryName = getHeaderNames(gqlQuery)[0];

    // Build query
    var params = "";

    if(paramQuery != null) params += "query: \"$paramQuery\",";

    if(options != null) {
      if(options["orderBy"] != null) params += "orderBy: \"${options["orderBY"]}\",";
      if(options["limit"] != null) params += "limit: ${options["start"]},";
      if(options["pageNum"] != null) params += "pageNum: ${options["pageNum"]},";
      if(options["pageSize"] != null) params += "pageSize: ${options["pageSize"]},";
    }

    if(params.endsWith(",")) params = params.substring(0, params.length - 1);

    var wrapper = "$queryName${params != "" ? "(" + params + ")" : ""}";
    var query = normalizedQuery.replaceFirst(queryName!, wrapper);

    // Execute query
    return _client.query(QueryOptions(document: gql(query)));

  }

  dynamic pagination(String gqlQuery, int pageNum, int pageSize, {String? paramQuery, dynamic options = const {}}) =>
    query(gqlQuery, options: {...options, "pageNum": pageNum, "pageSize": pageSize});

  dynamic count(String modelName, paramQuery, {dynamic options}) {
    var gqlQuery = """
    {
      ${modelName}Count {
        count
      }
    }
    """;
    return query(gqlQuery, paramQuery: paramQuery, options: {...options, "cacheQuery": false});
  }

  // TODO Check options & refetchQueries

  dynamic detail(String gqlQuery, int id, {dynamic options}) {

    var normalizedQuery = normalizeQuery(gqlQuery);
    var queryName = getHeaderNames(normalizedQuery)[0];

    // Build query
    var wrapper = "${queryName}(id: $id)";
    var query = normalizedQuery.replaceAll(queryName!, wrapper);

    //  Execute query
    return _client.query(QueryOptions(document: gql(query)));
    
  }

  dynamic save(String gqlQuery, int id, {dynamic options}) {
    var query = normalizeQuery(gqlQuery);
    return _client.mutate(MutationOptions(document: gql(query)));
  }

  dynamic set(String gqlQuery, {dynamic options}) {
    return _client.mutate(MutationOptions(document: gql(gqlQuery)));
  }

  dynamic delete(String gqlQuery, {dynamic options}) {
    var query = normalizeQuery(gqlQuery);
    return _client.mutate(MutationOptions(document: gql(gqlQuery)));
  }

  mutate(String mutation) {
    // TODO check mutations
  }

  String normalizeQuery(String gqlQuery) {
    var res = gqlQuery.trim();
    res = res.replaceAll(RegExp(r'mutation .*?\)'), ""); // Remove mutation header
    res = res.substring(1, res.length - 1);
    res = res.replaceAll(RegExp(r'\n'), " ");
    res = res.replaceAll(RegExp(r'{'), " { ");
    res = res.replaceAll(RegExp(r'}'), " } ");
    res = res.replaceAll(RegExp(r'{'), " { id "); // Auto inclide id attr to every model
    res = res.replaceAll(RegExp(r'[\s,]+'), " ").trim();
    res = "{ $res }";
    return res;
  }

  List<String?> getHeaderNames(String gqlQuery) {
    var regex = RegExp(r'[\w]+ {');
    var query = gqlQuery.replaceAll(RegExp(r'\(.*?\)'), ""); // Remove arguments
    var match = regex.allMatches(query);

    if(match.isNotEmpty)
      return match.map((model) => model.group(0)?.replaceAll(RegExp(r' {'), "")).toList(); // Word and a { after

    return [];
  }

  List<String?> getModelNames(String gqlQuery) {
    var models = getHeaderNames(gqlQuery).map((model) {
      var regex = RegExp(r'^\w');
      model = model
          ?.replaceAll(RegExp(r'Pagination\$'), "") // Remove pagination suffix
          .replaceAll(RegExp(r'^set'), "") // Remove set prefix
          .replaceAll(RegExp(r'^save'), "") // Remove save prefix
          .replaceAll(RegExp(r'^delete'), ""); // Remove delete prefix

      for(var match in regex.allMatches(model!))
        model = model!.substring(0, match.start) + model.substring(match.start, match.start + 1).toLowerCase() + model.substring(match.start + 1); //Start with lowercase

      return model;
    });

    List<String?> res = [];
    for(var model in models)
      if(SINGULARS[model] != null)
        res.add(SINGULARS[model]);

    return res;

  }

  bool hasCommonModels(String gqlQueryA, String gqlQueryB) {

    var aModels = getModelNames(gqlQueryA);
    var bModels = getModelNames(gqlQueryB);

    for(var aModel in aModels)
      for(var bModel in bModels)
        if(aModel == bModel)
          return true;

    return false;

  }

}