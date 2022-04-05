import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reference_v2/ui/common/loading.dart';
import 'package:reference_v2/ui/common/styles.dart';
import '../../data/model/team.dart';
import '../../domain/team_domain.dart';
import '../../utils/globals.dart';

class DetailTeam extends StatefulWidget {

  const DetailTeam({Key? key}) : super(key: key);

  @override
  _DetailTeamState createState() => _DetailTeamState();

}

class _DetailTeamState extends State<DetailTeam> {

  late var viewModelTeamDetail = ViewModelTeamDetail(() => setState((){}));
  Team? team;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: team == null ? const LoadingComponent(message: "") : getDetail(),
      )
    );
  }

  Widget getDetail() {
    return Padding(
      padding: EdgeInsets.only(left: 0.1.sw, right: 0.1.sw),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 0.05.sh),
            Text(team!.toJSON().toString()),
            SizedBox(height: 0.05.sh),
            SizedBox(
              width: 1.sw,
              height: 0.07.sh,
              child: ElevatedButton(
                style: BUTTON_STYLE(context, color: Theme.of(context).accentColor),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/examples/teams/form",
                    arguments: {
                      "team": team,
                      "type": FORM_TYPE.SET
                    }
                  );
                },
                child: const Text("Edit")
              ),
            ),
            SizedBox(height: 0.05.sh),
            SizedBox(
              width: 1.sw,
              height: 0.07.sh,
              child: ElevatedButton(
                style: BUTTON_STYLE(context, color: Theme.of(context).highlightColor),
                onPressed: () async {
                  var result = await viewModelTeamDetail.deleteTeam(team!);

                  if(!result)
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("An error has ocurred"),
                    ));

                  if(result) Navigator.pop(context, result);
                },
                child: const Text("Delete")
              ),
            ),
          ],
        ),
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

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var args = ModalRoute.of(context)!.settings.arguments! as dynamic;
      setState(() {
        team = args["team"] as Team?;
      });
    });

  }

}