import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/validator.dart';

class Login extends StatefulWidget {

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                onChanged: (value) {
                  setState((){});
                },
                decoration: InputDecoration(
                  fillColor: Theme.of(context).focusColor,
                  filled: _email.text.isNotEmpty,
                  border: InputBorder.none,
                  hintText: "Username",
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
                  suffixIcon: _email.text.isNotEmpty && emailRegex.hasMatch(_email.text)
                    ? Icon(Icons.check, color: Theme.of(context).accentColor)
                    : const SizedBox()
                ),
              ),
              SizedBox(height: 0.05.sh),
              TextFormField(
                controller: _password,
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (value) {
                  setState((){});
                },
                decoration: InputDecoration(
                  fillColor: Theme.of(context).focusColor,
                  filled: _password.text.isNotEmpty,
                  border: InputBorder.none,
                  hintText: "Password",
                  contentPadding: EdgeInsets.all(18.sp),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.sp),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  prefixIcon: Icon(Icons.password, color: Theme.of(context).primaryColor),
                  suffixIcon: _password.text.isNotEmpty
                      ? Icon(Icons.check, color: Theme.of(context).accentColor)
                      : const SizedBox()
                ),
              ),
              SizedBox(height: 0.05.sh),
              SizedBox(
                width: 1.sw,
                height: 0.07.sh,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).highlightColor),
                    elevation: MaterialStateProperty.all<double>(10),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.sp),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Iniciar sesión")
                ),
              ),
              SizedBox(height: 0.05.sh),
            ],
          ),
        )
      )
    );
  }

}