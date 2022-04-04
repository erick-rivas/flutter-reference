import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reference_v2/data/apis/api_response.dart';
import 'package:reference_v2/data/model/user.dart';
import 'package:reference_v2/ui/common/loading.dart';

import '../../domain/user_domain.dart';
import '../common/error.dart';

class ListUser extends StatefulWidget {

  const ListUser({Key? key}) : super(key: key);

  @override
  _ListUserState createState() => _ListUserState();

}

class _ListUserState extends State<ListUser> {

  final viewModelUserList = ViewModelUserList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (){
          var apiResponse = viewModelUserList.response;
          if(apiResponse.status == Status.LOADING) return const LoadingComponent();
          if(apiResponse.status == Status.COMPLETED) return buildUserList(apiResponse.data);
          if(apiResponse.status == Status.ERROR) return const ErrorComponent();
          if(apiResponse.status == Status.INITIAL) return Container();
        }(),
      )
    );
  }

  Widget buildUserList(List<User> users) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 0.1.sw, right: 0.1.sw),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Users"),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Create")
                  )
                ],
              ),
              Expanded(
                child: Align(
                  alignment:Alignment.topLeft,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) =>
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(users[index].username!),
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
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) refresh();
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    viewModelUserList.listUsers();
  }

}