import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reference_v2/data/apis/api_response.dart';
import 'package:reference_v2/domain/team_domain.dart';
import 'package:reference_v2/ui/common/loading.dart';
import '../../data/model/team.dart';
import '../common/error.dart';

class FormTeams extends StatefulWidget {

  const FormTeams({Key? key}) : super(key: key);

  @override
  _FormTeamsState createState() => _FormTeamsState();

}

class _FormTeamsState extends State<FormTeams> {

  late var viewModelTeamForm = ViewModelTeamForm(refresh);
  late Team? team;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _marketValue = TextEditingController();
  String? _rival = "Select rival";
  XFile? _logo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (){
          var apiResponse = viewModelTeamForm.response;
          if(apiResponse.status == Status.LOADING) return const LoadingComponent();
          if(apiResponse.status == Status.COMPLETED) return Container();
          if(apiResponse.status == Status.ERROR) return const ErrorComponent();
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
              decoration: InputDecoration(
                fillColor: Theme.of(context).focusColor,
                filled: _name.text.isNotEmpty,
                border: InputBorder.none,
                hintText: "Name",
                contentPadding: EdgeInsets.all(18.sp),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                suffixIcon: _name.text.isNotEmpty
                  ? Icon(Icons.check, color: Theme.of(context).accentColor)
                  : const SizedBox()
              ),
            ),
            SizedBox(height: 0.05.sh),
            TextFormField(
              controller: _description,
              keyboardType: TextInputType.text,
              onChanged: (value) => setState((){ team?.description = _description.text; }),
              decoration: InputDecoration(
                fillColor: Theme.of(context).focusColor,
                filled: _description.text.isNotEmpty,
                border: InputBorder.none,
                hintText: "Desrciption",
                contentPadding: EdgeInsets.all(18.sp),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                suffixIcon: _description.text.isNotEmpty
                  ? Icon(Icons.check, color: Theme.of(context).accentColor)
                  : const SizedBox()
              ),
            ),
            SizedBox(height: 0.05.sh),
            TextFormField(
              controller: _marketValue,
              keyboardType: TextInputType.number,
              onChanged: (value) => setState((){ team?.marketValue = double.parse(_marketValue.text); }),
              decoration: InputDecoration(
                fillColor: Theme.of(context).focusColor,
                filled: _marketValue.text.isNotEmpty,
                border: InputBorder.none,
                hintText: "Market value",
                contentPadding: EdgeInsets.all(18.sp),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                suffixIcon: _marketValue.text.isNotEmpty
                  ? Icon(Icons.check, color: Theme.of(context).accentColor)
                  : const SizedBox()
              ),
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
              child: _logo == null ? Image.asset("assets/images/image_pick.png") : Image.file(File(_logo!.path)),
              onTap: () {
                ImagePicker().pickImage(source: ImageSource.gallery)
                  .then((value) => setState((){
                    if(value != null)
                      _logo = value;
                }));
              },
            ),
            SizedBox(height: 0.05.sh),
            ElevatedButton(
              onPressed: () {
                viewModelTeamForm.saveTeam();
              },
              child: Text("Save")
            )
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
    });

  }

  void refresh() => setState(() {});

}