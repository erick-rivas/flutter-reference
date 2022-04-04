import 'package:flutter/cupertino.dart';

import '../data/apis/api_response.dart';
import '../data/model/user.dart';
import '../data/repository/user_repository.dart';

class ViewModelUserList with ChangeNotifier {

  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  ApiResponse get response {
    return _apiResponse;
  }

  UserRepository userRepository = UserRepository();

  List<User> _users = [];

  void listUsers() async {

    _apiResponse = ApiResponse.loading('Fetching pokemon');
    notifyListeners();

    try {

      List<User> users = await userRepository.listUser();
      _users.addAll(users);
      _apiResponse = ApiResponse.completed(_users);

    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }

    notifyListeners();

  }

}