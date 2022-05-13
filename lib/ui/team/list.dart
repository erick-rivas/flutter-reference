import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reference/repository/base_response.dart';
import 'package:reference/ui/common/styles.dart';
import 'package:reference/seed/models/team.dart';
import 'package:reference/seed/utils.dart';
import 'package:reference/seed/helpers/error.dart';
import 'package:reference/seed/helpers/loading.dart';
import 'package:reference/view_model/team_vm.dart';

class ListTeams extends StatefulWidget {

  const ListTeams({Key? key}) : super(key: key);

  @override
  _ListTeamsState createState() => _ListTeamsState();

}

class _ListTeamsState extends State<ListTeams> {

  final ScrollController _scrollController =  ScrollController();
  late var viewModelTeamList = ViewModelTeamList(() => setState((){}));
  var fetchingScroll = false;

  BaseResponse? apiResponse;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: () {
          apiResponse = viewModelTeamList.response;
          if(apiResponse!.status == Status.LOADING) return LoadingComponent(message: apiResponse!.message!);
          if(apiResponse!.status == Status.COMPLETED) return buildUserList();
          if(apiResponse!.status == Status.ERROR) return ErrorComponent(message: apiResponse!.message!);
          if(apiResponse!.status == Status.INITIAL) return Container();
        }(),
      )
    );
  }

  Widget buildUserList() {
    return Padding(
      padding: EdgeInsets.all(0.1.sw),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Teams"),
              ElevatedButton(
                style: BUTTON_STYLE(context, color: Theme.of(context).highlightColor),
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    "/examples/teams/form",
                    arguments: {
                      "team": Team.fromJSON(null),
                      "type": FORM_TYPE.SAVE
                    }
                  );
                  setState(() {});
                  viewModelTeamList.reloadTeams();
                },
                child: const Text("Create")
              ),
            ],
          ),
          SizedBox(height: 0.03.sh,),
          SizedBox(
            width: 1.sw,
            height: 0.7.sh,
            child: Align(
              alignment:Alignment.topLeft,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                itemCount: viewModelTeamList.teams.length + 1,
                itemBuilder: (BuildContext context, int index) => () {
                  if(index == viewModelTeamList.teams.length)
                    return fetchingScroll
                      ? ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center ,
                          children: const [CircularProgressIndicator()]
                        )
                      )
                      : const SizedBox();

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(viewModelTeamList.teams[index].name!),
                        ElevatedButton(
                          style: BUTTON_STYLE(context, color: Theme.of(context).accentColor),
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              "/examples/teams/detail",
                              arguments: {
                                "team": viewModelTeamList.teams[index],
                              }
                            );
                            setState(() {});
                            viewModelTeamList.reloadTeams();
                          },
                          child: const Text("Details")
                        ),
                      ],
                    ),
                  );
                } ()
              ),
            ),
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
    _scrollController.addListener(() async {
      if (_scrollController.position.extentAfter < 10 && !fetchingScroll) {
        setState(() { fetchingScroll = true; });
        await viewModelTeamList.listTeams();
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() { fetchingScroll = false; });
      }
    });
    viewModelTeamList.listTeams();
  }

}