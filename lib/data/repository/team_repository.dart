import 'package:reference_v2/data/apis/graphql.dart';
import 'package:reference_v2/data/apis/http_handler.dart';
import 'package:reference_v2/data/model/team.dart';

import '../../settings.dart';

class TeamRepository {

  GraphQL graphQL = GraphQL(GRAPH_URL);

  Future<dynamic> listAllTeamsId() async {

    String query = "{ teams { } }";

    var res = await graphQL.query(query);

    if (res.data != null)
      return List<int>.from(res.data["teams"].map((team) => team["id"]).toList());

    return [];

  }

  Future<dynamic> listTeams() async {

    String listGQL = """{
      teamPagination {
        totalPages
        teams {
          name
          description
          marketValue
          createdAt
          logo { }
          rival { }
          identityDocs { }
          players { }
        }
      }
    }""";

    var res = await graphQL.pagination(listGQL, 1, 15);

    if (res.data != null)
      return List<Team>.from(res.data["teamPagination"]["teams"].map((team) => Team.fromJSON(team)).toList());

    return [];

  }

  Future<dynamic> saveTeam(Team team, String logoPath) async {

    HttpHandler handler = HttpHandler();
    var response = handler.UPLOAD_FILE(SERVER_URL + "/files/", logoPath);

    // TODO

  }

  Future<dynamic> setTeam(Team team) async {

  }

}