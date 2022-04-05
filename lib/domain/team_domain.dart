import 'package:reference_v2/data/model/team.dart';
import 'package:reference_v2/data/repository/team_repository.dart';
import '../data/apis/api_response.dart';

class ViewModelTeamList {

  final Function refresh;
  ViewModelTeamList(this.refresh);

  final TeamRepository _teamRepository = TeamRepository();
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  List<Team> _teams = [];
  int _page = 1;

  ApiResponse get response => _apiResponse;
  List<Team> get teams => _teams;

  listTeams() async {

    if(_apiResponse.status == Status.INITIAL) {
      _apiResponse = ApiResponse.loading('Fetching data');
      refresh();
    }

    try {

      List<Team> teams = await _teamRepository.listTeams(_page, 15);
      _teams.addAll(teams);
      _apiResponse = ApiResponse.completed(_teams);
      _page++;

    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }

    refresh();

  }

  reloadTeams() {
    _page = 1;
    _teams.clear();
    _apiResponse = ApiResponse.initial('Empty data');
    listTeams();
  }

}

class ViewModelTeamForm {

  final Function refresh;
  ViewModelTeamForm(this.refresh);

  final TeamRepository _teamRepository = TeamRepository();
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  List<int> _teamsId = [];

  ApiResponse get response => _apiResponse;
  List<int> get teamsId => _teamsId;

  listTeamsId() async {

    try {
      _teamsId = await _teamRepository.listAllTeamsId();
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }

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