import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reference_v2/seed/network.dart';
import 'package:reference_v2/ui/router.dart';
import 'package:reference_v2/ui/common/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);
  late Stream<NetworkStatus> networkStatus;

  void initConnectionListener() {
    var networkStatusService = NetworkStatusService();
    networkStatusService.init();
    networkStatus = networkStatusService.networkStatusController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MaterialApp(
        builder: (context, widget) {
          initConnectionListener();
          ScreenUtil.setContext(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        theme: THEME,
        routes: router,
        initialRoute: '/examples/teams',
      ),
    );

  }

}