import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reference/repository/base_response.dart';
import 'package:reference/ui/common/styles.dart';
import 'package:reference/seed/models/team.dart';
import 'package:reference/seed/utils.dart';
import 'package:reference/seed/helpers/error.dart';
import 'package:reference/seed/helpers/loading.dart';
import 'package:reference/view_model/team_vm.dart';
import 'package:reference/settings.dart';

class FormTeams extends StatefulWidget {

  const FormTeams({Key? key}) : super(key: key);

  @override
  _FormTeamsState createState() => _FormTeamsState();

}

class _FormTeamsState extends State<FormTeams> {

  late var viewModelTeamForm = ViewModelTeamForm(() => setState((){}));
  late FORM_TYPE formType;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _marketValue = TextEditingController();
  String? _rival = "Select rival";
  XFile? _logo;
  Team? team;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (){
          var apiResponse = viewModelTeamForm.response;
          if(apiResponse.status == Status.LOADING) return LoadingComponent(message: apiResponse.message!);
          if(apiResponse.status == Status.COMPLETED) return Container();
          if(apiResponse.status == Status.ERROR) return ErrorComponent(message: apiResponse.message!);
          if(apiResponse.status == Status.INITIAL) return getForm();
        }(),
      )
    );
  }

  Widget getForm() {
    return Padding(
      padding: EdgeInsets.only(left: 0.1.sw, right: 0.1.sw),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 0.05.sh),
            TextFormField(
              controller: _name,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => setState((){ team?.name = _name.text; }),
              decoration: INPUT_STYLE(context, controller: _name, hint: "Name"),
            ),
            SizedBox(height: 0.05.sh),
            TextFormField(
              controller: _description,
              keyboardType: TextInputType.text,
              onChanged: (value) => setState((){ team?.description = _description.text; }),
              decoration: INPUT_STYLE(context, controller: _description, hint: "Description"),
            ),
            SizedBox(height: 0.05.sh),
            TextFormField(
              controller: _marketValue,
              keyboardType: TextInputType.number,
              onChanged: (value) => setState((){ team?.marketValue = double.parse(_marketValue.text); }),
              decoration: INPUT_STYLE(context, controller: _marketValue, hint: "Market value"),
            ),
            SizedBox(height: 0.05.sh),
            DropdownButton(
              value: _rival,
              onChanged: (value) => setState(() {

                setState(() {
                  _rival = value as String?;
                });

                if(_rival != "Select rival")
                  team?.rival = Team.fromJSON({"id": int.parse(_rival!)});
                else
                  team?.rival = null;

              }),
              items: [
                const DropdownMenuItem(
                  child: Text("Select rival"),
                  value: "Select rival",
                ),
                ...viewModelTeamForm.teamsId.map((teamId) =>
                  DropdownMenuItem(
                    child: Text(teamId.toString()),
                    value: teamId.toString(),
                  )
                ).toList()
              ],
            ),
            SizedBox(height: 0.05.sh),
            GestureDetector(
              child: () {

                if(team != null && team!.logo != null && team!.logo["name"] != null)
                  return Image.network("$MEDIA_URL/" + team!.logo["name"]);

                if(_logo == null)
                  return Image.asset("assets/images/image_pick.png");

                return Image.file(File(_logo!.path));

              } (),
              onTap: () {
                ImagePicker().pickImage(source: ImageSource.gallery)
                  .then((value) => setState((){
                    if(value != null)
                      _logo = value;
                }));
              },
            ),
            SizedBox(height: 0.05.sh),
            SizedBox(
              width: 1.sw,
              height: 0.07.sh,
              child: ElevatedButton(
                style: BUTTON_STYLE(context, color: Theme.of(context).accentColor),
                onPressed: () async {
                  var result = true;

                  if(formType == FORM_TYPE.SAVE)
                    result = await viewModelTeamForm.saveTeam(team!, _logo!.path);
                  else
                    result = await viewModelTeamForm.setTeam(team!, _logo == null ? null : _logo!.path);

                  if(!result)
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("An error has ocurred"),
                    ));

                  if(result) Navigator.pop(context, result);
                },
                child: const Text("Save")
              ),
            ),
            SizedBox(height: 0.05.sh),
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

    viewModelTeamForm.listTeamsId();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var args = ModalRoute.of(context)!.settings.arguments! as dynamic;
      team = args["team"] as Team?;
      formType = args["type"] as FORM_TYPE;
      initData();
    });

  }

  void initData() {

    _name.text = team!.name??"";
    _description.text = team!.description??"";
    _marketValue.text = team!.marketValue == null ? "" : team!.marketValue.toString();
    _rival = team!.rival == null || team!.rival!.id == null ? "Select rival" : team!.rival!.id!.toString();

  }

}