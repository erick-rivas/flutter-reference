import 'package:reference/repository/team_repository.dart';
import 'package:reference/repository/base_response.dart';
import 'package:reference/seed/models/team.dart';

import '../seed/datasources/response.dart';

class ViewModelTeamList {

  final Function refresh;
  ViewModelTeamList(this.refresh);

  final TeamRepository _teamRepository = TeamRepository();
  BaseResponse _apiResponse = BaseResponse.initial('Empty data');

  List<Team> _teams = [];
  int _page = 1;

  BaseResponse get response => _apiResponse;
  List<Team> get teams => _teams;

  listTeams() async {

    if(_apiResponse.status == Status.INITIAL) {
      _apiResponse = BaseResponse.loading('Fetching data');
      refresh();
    }

    Result result = await _teamRepository.listTeams(_page, 15);

    if(result.status == StatusResponse.OK) {
      _teams.addAll(teams);
      _apiResponse = BaseResponse.completed(_teams);
      _page++;
    }
    else {
      _apiResponse = BaseResponse.error(result.status.toString());
    }

    refresh();

  }

  reloadTeams() {
    _page = 1;
    _teams.clear();
    _apiResponse = BaseResponse.initial('Empty data');
    listTeams();
  }

}

class ViewModelTeamForm {

  final Function refresh;
  ViewModelTeamForm(this.refresh);

  final TeamRepository _teamRepository = TeamRepository();
  BaseResponse _apiResponse = BaseResponse.initial('Empty data');

  List<int> _teamsId = [];

  BaseResponse get response => _apiResponse;
  List<int> get teamsId => _teamsId;

  listTeamsId() async {

    Result result = await _teamRepository.listAllTeamsId();

    if(result.status == StatusResponse.OK)
      _teamsId = result.data;
    else
      _apiResponse = BaseResponse.error(result.status.toString());

    refresh();

  }

  saveTeam(Team team, String logoPath) async {
    return await _teamRepository.saveTeam(team, logoPath);
  }

  setTeam(Team team, String? logoPath) async {
    return await _teamRepository.setTeam(team, logoPath);
  }

}

class ViewModelTeamDetail {

  final Function refresh;
  ViewModelTeamDetail(this.refresh);

  final TeamRepository _teamRepository = TeamRepository();

  deleteTeam(Team team) async {
    return await _teamRepository.deleteTeam(team);
  }

}