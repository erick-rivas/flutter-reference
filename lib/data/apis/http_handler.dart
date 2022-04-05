import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'api_exception.dart';

class HttpHandler {

  Future<dynamic> GET(String url, {dynamic params}) async {
    dynamic responseJson;

    try{
      var response = await get(Uri.parse(url + (params != null ? jsonEncode(params) : "")), headers: _getHeaders())
        .timeout(const Duration(seconds: 10));
      responseJson =  _getResponse(response);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  Future<dynamic> POST(String url, Map<String, dynamic> body) async {

    dynamic responseJson;

    try{
      var response = await post(Uri.parse(url), body: jsonEncode(body), headers: _getHeaders())
        .timeout(const Duration(seconds: 10));
      responseJson =  _getResponse(response);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;

  }

  Future<dynamic> UPLOAD_FILE(String url, String path) async {

    dynamic responseJson;

    try {
      var request = MultipartRequest("POST", Uri.parse(url));
      request.files.add(await MultipartFile.fromPath("file", path, contentType: MediaType("multipart", "form-data")));
      var response = await request.send();
      var responseStr = await Response.fromStream(response);
      responseJson = _getResponse(responseStr);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
    
  }

  dynamic _getHeaders() {
    String token = "";
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Token $token"
    };
  }

  dynamic _getResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
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