import 'package:reference/seed/api.dart';
import 'package:reference/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../seed/datasources/response.dart';

class AuthRepository {

  HttpHandler httpHandler = HttpHandler();

  login(String email, String password) async {

    var res = await httpHandler
      .POST(API_URL + "/auth/login/", {"email": email, "password": password});

    if(res.status == StatusResponse.OK) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", res.data["key"]);
      prefs.setInt("id", res.data["user"]);

      return Result(data: {}, status: res.status);

    }

    return Result(data: res.data, status: res.status);

  }

  logout() async {

    var res = await httpHandler.POST(API_URL + "/auth/logout/", {});

    if(res.status == StatusResponse.OK) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
      prefs.remove("id");

      return Result(data: {}, status: res.status);

    }

    return Result(data: res.data, status: res.status);

  }

}