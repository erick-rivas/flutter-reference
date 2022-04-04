import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reference_v2/data/apis/api_response.dart';
import 'package:reference_v2/domain/team_domain.dart';
import 'package:reference_v2/ui/common/loading.dart';
import '../../data/model/team.dart';
import '../common/error.dart';

class ListTeams extends StatefulWidget {

  const ListTeams({Key? key}) : super(key: key);

  @override
  _ListTeamsState createState() => _ListTeamsState();

}

class _ListTeamsState extends State<ListTeams> {

  late var viewModelTeamList = ViewModelTeamList(refresh);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: () {
          var apiResponse = viewModelTeamList.response;
          print(apiResponse.status);
          if(apiResponse.status == Status.LOADING) return const LoadingComponent();
          if(apiResponse.status == Status.COMPLETED) return buildUserList(apiResponse.data);
          if(apiResponse.status == Status.ERROR) return const ErrorComponent();
          if(apiResponse.status == Status.INITIAL) return Container();
        }(),
      )
    );
  }

  Widget buildUserList(List<Team> teams) {
    return Padding(
      padding: EdgeInsets.only(left: 0.1.sw, right: 0.1.sw),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Teams"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/examples/teams/create",
                    arguments: {
                      "team": Team.fromJSON(null)
                    }
                  );
                },
                child: const Text("Create")
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment:Alignment.topLeft,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: teams.length,
                itemBuilder: (BuildContext context, int index) =>
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(teams[index].name!),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Details")
                        )
                      ],
                    )
                  )
              )
            )
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    viewModelTeamList.listTeams();
  }

  void refresh() => setState(() {});

}