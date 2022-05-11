import 'package:graphql/client.dart';
import 'package:reference_v2/seed/cache.dart';
import 'package:reference_v2/settings.dart';
import 'package:reference_v2/seed/data/gql/const.dart';

class GraphQLCore {

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
    var regex = RegExp(r'[\w]+ {'); // Word and a { after
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

  dynamic manageResponse(Future<QueryResult> futureResult, String query, {bool? useCache, String? method, dynamic variables}) async {
    var res = await futureResult;

    if(res.hasException) {
      if(res.exception?.linkException is NetworkException) {
        if(useCache != null && useCache)
          CacheAPI().savePendingGQLRequest(GRAPH_URL, method!, query, variables: variables??{});
        throw NetworkException(uri: Uri.parse(GRAPH_URL));
      }
      else
        throw Exception("A problem has ocurred with GrahpQL: ${res.exception!.linkException!.originalException}");
    }

    assert(res.data != null);

    if(res.data!.isNotEmpty)
      return res.data;

    return {};
  }

}