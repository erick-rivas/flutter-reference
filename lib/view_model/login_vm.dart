import 'package:flutter/cupertino.dart';
import 'package:reference/repository/auth_repository.dart';

import '../repository/base_response.dart';
import '../seed/datasources/response.dart';

class ViewModelLoginForm {

  final Function refresh;
  ViewModelLoginForm(this.refresh);

  final AuthRepository _authRepository = AuthRepository();
  BaseResponse _apiResponse = BaseResponse.initial('Empty data');

  BaseResponse get response => _apiResponse;

  login(String username, String password) async {

    _apiResponse = BaseResponse.loading("Sign in...");
    refresh();

    Result result = await _authRepository.login(username, password);

    if(result.status == StatusResponse.OK) {
      _apiResponse = BaseResponse.completed("");
      refresh();
    }
    else {
      _apiResponse = BaseResponse.error("An error has ocurred");
      refresh();
    }

  }
  
}