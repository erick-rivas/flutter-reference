import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:convert';

import 'api_exception.dart';

class HttpHandler {

  Future<dynamic> GET(String url) async {
    dynamic responseJson;

    try{
      Response response = await get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson =  _getResponse(response);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future<dynamic> POST(String url, Map<String, dynamic> body, Map<String, String> headers) async {

    dynamic responseJson;

    try{
      Response response = await post(Uri.parse(url), body: jsonEncode(body), headers: headers).timeout(const Duration(seconds: 10));
      responseJson =  _getResponse(response);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  dynamic _getResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }

}