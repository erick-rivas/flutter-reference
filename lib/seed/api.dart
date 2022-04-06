import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:reference_v2/seed/data/apis/http_handler.dart';
import 'data/apis/api_exception.dart';

/// @module api

class HttpHandler extends HttpHandlerCore {

  /// Return a http get request as Map<dynamic, dynamic>
  /// @param [url] target url
  /// @param [params] extra query params
  /// @example
  /// var response = api.GET(API_URL + "/player", params: {"name": "cristiano"})
  /// which will request like http://localhost:8008/player?name=cristiano
  Future<dynamic> GET(String url, {dynamic params}) async {
    dynamic responseJson;

    try{
      var response = await get(Uri.parse(url).replace(queryParameters: params), headers: getHeaders())
        .timeout(const Duration(seconds: 10));
      responseJson = getResponse(response);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  /// Return a http post request as Map<dynamic, dynamic>
  /// @param [url] target url
  /// @param [body] body request
  /// @example
  /// var response = api.GET(API_URL + "/players", body: {"name": "cristiano"})
  Future<dynamic> POST(String url, Map<String, dynamic> body) async {

    dynamic responseJson;

    try{
      var response = await post(Uri.parse(url), body: jsonEncode(body), headers: getHeaders())
        .timeout(const Duration(seconds: 10));
      responseJson =  getResponse(response);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;

  }

  /// Return a http put request as Map<dynamic, dynamic>
  /// @param [url] target url
  /// @param [body] body request
  /// @example
  /// var response = api.GET(API_URL + "/players", body: {"id": 1, "name": "cristiano"})
  Future<dynamic> PUT(String url, Map<String, dynamic> body) async {

    dynamic responseJson;

    try{
      var response = await put(Uri.parse(url), body: jsonEncode(body), headers: getHeaders())
        .timeout(const Duration(seconds: 10));
      responseJson =  getResponse(response);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;

  }

  /// Return a http delete request as Map<dynamic, dynamic>
  /// @param [url] target url
  /// @param [body] body request
  /// @example
  /// var response = api.GET(API_URL + "/players", body: {"id": 1})
  Future<dynamic> DELETE(String url, Map<String, dynamic> body) async {

    dynamic responseJson;

    try{
      var response = await delete(Uri.parse(url), body: jsonEncode(body), headers: getHeaders())
        .timeout(const Duration(seconds: 10));
      responseJson =  getResponse(response);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;

  }

  /// Return a http response as Map<dynamic, dynamic> after upload a file
  /// @param [url] target url
  /// @param [body] body request
  /// @example
  /// var response = api.GET(API_URL + "/players", body: {"id": 1})
  Future<dynamic> UPLOAD_FILE(String url, {String? path, ByteData? bytes}) async {

    dynamic responseJson;

    try {
      var request = MultipartRequest("POST", Uri.parse(url));

      if (path != null)
        request.files.add(await MultipartFile.fromPath("file", path, contentType: MediaType("multipart", "form-data")));
      else
        request.files.add(MultipartFile.fromBytes("file", bytes!.buffer.asInt8List()));

      var response = await request.send();
      var responseStr = await Response.fromStream(response);
      responseJson = getResponse(responseStr);
    }
    on SocketException {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;

  }

}