import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:reference_v2/domain/team_domain.dart';
import 'package:reference_v2/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MaterialApp(
        builder: (context, widget) {
          ScreenUtil.setContext(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        theme: ThemeData(
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
        ),
        routes: router,
        initialRoute: '/examples/teams',
      ),
    );

  }

}