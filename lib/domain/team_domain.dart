import 'package:flutter/cupertino.dart';
import 'package:reference_v2/data/model/team.dart';
import 'package:reference_v2/data/repository/team_repository.dart';
import '../data/apis/api_response.dart';

class ViewModelTeamList with ChangeNotifier {

  final Function refresh;
  ViewModelTeamList(this.refresh);

  ApiResponse _apiResponse = ApiResponse.initial('Empty data');
  final TeamRepository _teamRepository = TeamRepository();
  final List<Team> _teams = [];

  ApiResponse get response => _apiResponse;

  listTeams() async {

    _apiResponse = ApiResponse.loading('Fetching pokemon');
    refresh();

    try {

      List<Team> teams = await _teamRepository.listTeams();
      _teams.addAll(teams);
      _apiResponse = ApiResponse.completed(_teams);

    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }

    refresh();

  }

}

class ViewModelTeamForm with ChangeNotifier {

  final Function refresh;
  ViewModelTeamForm(this.refresh);

  final TeamRepository _teamRepository = TeamRepository();
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');
  List<int> _teamsId = [];
  Team? _team;

  ApiResponse get response => _apiResponse;
  List<int> get teamsId => _teamsId;

  void set team(Team team) => _team = team;

  listTeamsId() async {

    try {
      _teamsId = await _teamRepository.listAllTeamsId();
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }

    refresh();

  }

  saveTeam() async {



  }

}