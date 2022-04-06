import 'package:reference_v2/seed/models/team.dart';
import 'package:reference_v2/seed/data/gql/queries.dart';
import 'package:reference_v2/settings.dart';
import 'package:reference_v2/seed/gql.dart';
import 'package:reference_v2/seed/api.dart';

class TeamRepository {

  GraphQL graphQL = GraphQL();

  Future<dynamic> listAllTeamsId() async {

    try {

      String query = "{ teams { } }";

      var res = await graphQL.query(query);

      if (res.data != null)
        return List<int>.from(res.data["teams"].map((team) => team["id"]).toList());

      return [];

    } catch(e) {
      print(e);
    }

  }

  Future<dynamic> listTeams(int page, int number) async {

    try {

      String listGQL = """{
        teamPagination {
          totalPages
          teams {
            name
            description
            marketValue
            createdAt
            logo {
              name
            }
            rival { }
            identityDocs { }
            players { }
          }
        }
      }""";

      var res = await graphQL.pagination(listGQL, page, number);

      if (res.data != null)
        return List<Team>.from(res.data["teamPagination"]["teams"].map((team) => Team.fromJSON(team)).toList());

      return [];

    } catch(e) {
      print(e);
    }

  }

  Future<dynamic> saveTeam(Team team, String logoPath) async {

    try {

      HttpHandler handler = HttpHandler();
      var response = await handler.UPLOAD_FILE(API_URL + "/files/", path: logoPath);
      team.logo = response["id"];

      var res = await graphQL.save(SAVE_TEAM, variables: team.toJSON());
      return !res.hasException;

    } catch(e) {
      print(e);
    }

  }

  Future<dynamic> setTeam(Team team, String? logoPath) async {

    try {

      if(logoPath != null) {
        HttpHandler handler = HttpHandler();
        var response = await handler.UPLOAD_FILE(API_URL + "/files/", path: logoPath);
        team.logo = response["id"];
      }

      team.logo = team.logo["id"];

      var res = await graphQL.set(SET_TEAM, variables: team.toJSON());
      return !res.hasException;

    } catch(e) {
      print(e);
    }

  }

  Future<dynamic> deleteTeam(Team team) async {

    try {
      var res = await graphQL.delete(DELETE_TEAM, variables: team.toJSON());
      return !res.hasException;
    } catch(e) {
      print(e);
    }

  }

}