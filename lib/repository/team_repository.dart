import 'package:reference/seed/models/team.dart';
import 'package:reference/seed/datasources/gql/queries.dart';
import 'package:reference/settings.dart';
import 'package:reference/seed/gql.dart';
import 'package:reference/seed/api.dart';

import '../seed/datasources/response.dart';

class TeamRepository {

  GraphQL graphQL = GraphQL();

  Future<dynamic> listAllTeamsId() async {

    try {

      String query = "{ teams { } }";

      var res = await graphQL.query(query);
      var data = [];

      if(res.status == StatusResponse.OK)
        if(res.data != null)
          data = List<int>.from(res.data["teams"].map((team) => team["id"]).toList());

      return Result(data: data, status: res.status);

    } catch(e) {
      print(e);
      return Result(data: null, status: StatusResponse.UNKNOWN_ERROR);
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
      var data = [];

      if(res.status == StatusResponse.OK)
        if(res.data != null)
          data = List<Team>.from(res.data["teamPagination"]["teams"].map((team) => Team.fromJSON(team)).toList());

      return Result(data: data, status: res.status);

    } catch(e) {
      print(e);
      return Result(data: null, status: StatusResponse.UNKNOWN_ERROR);
    }

  }

  Future<dynamic> saveTeam(Team team, String logoPath) async {

    try {

      HttpHandler handler = HttpHandler();
      var response = await handler.UPLOAD_FILE(API_URL + "/files/", path: logoPath);
      team.logo = response["id"];

      var res = await graphQL.save(SAVE_TEAM, variables: team.toJSON());
      return res.status != StatusResponse.OK;

    } catch(e) {
      print(e);
      return false;
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
      return res.status != StatusResponse.OK;

    } catch(e) {
      print(e);
      return false;
    }

  }

  Future<dynamic> deleteTeam(Team team) async {

    try {
      var res = await graphQL.delete(DELETE_TEAM, variables: team.toJSON());
      return res.status != StatusResponse.OK;
    } catch(e) {
      print(e);
      return false;
    }

  }

}