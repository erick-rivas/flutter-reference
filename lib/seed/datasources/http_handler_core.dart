import 'dart:convert';
import 'response.dart';

class HttpHandlerCore {

  // Retrieve http headers
  dynamic getHeaders() {
    String token = "";
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Token $token"
    };
  }

  // Return the correct response
  dynamic manageResponse(var response) {

    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return Result(data: responseJson, status: StatusResponse.OK);
      case 400:
        return Result(data: null, status: StatusResponse.BAD_REQUEST);
      case 401:
      case 403:
        return Result(data: null, status: StatusResponse.UNAUTHORIZED);
      case 404:
        return Result(data: null, status: StatusResponse.NOT_FOUND);
      case 408:
        return Result(data: null, status: StatusResponse.TIME_OUT);
      case 500:
      default:
        return Result(data: null, status: StatusResponse.SERVER_ERROR);
    }
  }

}