import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reference/ui/common/styles.dart';
import 'package:reference/seed/utils.dart';
import 'package:reference/view_model/login_vm.dart';

import '../../repository/base_response.dart';
import '../../seed/helpers/error.dart';
import '../../seed/helpers/loading.dart';

class Login extends StatefulWidget {

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {

  final _email = TextEditingController();
  final _password = TextEditingController();

  late var viewModelLoginForm = ViewModelLoginForm(() => setState((){}));
  BaseResponse? apiResponse;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: () {
            apiResponse = viewModelLoginForm.response;
            if(apiResponse!.status == Status.COMPLETED) Future(() => Navigator.pushNamed(context, "/examples"));
            if(apiResponse!.status == Status.LOADING) return LoadingComponent(message: apiResponse!.message!);
            if(apiResponse!.status == Status.ERROR) return ErrorComponent(message: apiResponse!.message!);
            if(apiResponse!.status == Status.INITIAL) return buildView();
            return Container();
          }(),
        )
    );
  }

  Widget buildView() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(left: 0.1.sw, right: 0.1.sw),
          child: Column(
            children: [
              SizedBox(height: 0.05.sh),
              Image.asset("assets/images/logo.png"),
              SizedBox(height: 0.05.sh),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => setState((){}),
                decoration: INPUT_STYLE(context, controller: _email, validation: EMAIL_REGEX),
              ),
              SizedBox(height: 0.05.sh),
              TextFormField(
                controller: _password,
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (value) => setState((){}),
                decoration: INPUT_STYLE(context, controller: _password),
              ),
              SizedBox(height: 0.05.sh),
              SizedBox(
                width: 1.sw,
                height: 0.07.sh,
                child: ElevatedButton(
                    style: BUTTON_STYLE(context, color: Theme.of(context).highlightColor),
                    onPressed: () { viewModelLoginForm.login(_email.text, _password.text); },
                    child: const Text("Log in")
                ),
              ),
              SizedBox(height: 0.05.sh),
            ],
          ),
        ),
      ),
    );
  }

}