import 'dart:convert';
import 'api_exception.dart';

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

  // Throw http errors as exceptions
  dynamic getResponse(var response) {
    switch (response.statusCode) {
      case 200:
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