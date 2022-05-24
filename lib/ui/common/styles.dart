import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var THEME = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF272D2D),
  focusColor: const Color(0xFF50514F),
  primaryColor: const Color(0xFFF6F8FF),
  accentColor: const Color(0xFF23CE6B),
  highlightColor: const Color(0xFFA846A0),
  fontFamily: 'Georgia',
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.sp, fontWeight: FontWeight.bold),
    headline6: TextStyle(fontSize: 36.sp, fontStyle: FontStyle.italic),
    bodyText2: TextStyle(fontSize: 14.sp, fontFamily: 'Hind'),
  ),
);

BUTTON_STYLE(context, {required Color color}) => ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(color),
  elevation: MaterialStateProperty.all<double>(10),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.sp),
    ),
  ),
);

INPUT_STYLE(context, {required TextEditingController controller, String? hint, RegExp? validation}) => InputDecoration(
    fillColor: Theme.of(context).focusColor,
    filled: controller.text.isNotEmpty,
    border: InputBorder.none,
    hintText: hint,
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
    suffixIcon: () {
      var validate = true;
      if(validation != null) validate = validation.hasMatch(controller.text);
      return controller.text.isNotEmpty && validate
        ? Icon(Icons.check, color: Theme.of(context).accentColor)
        : const SizedBox();
    } ()

);