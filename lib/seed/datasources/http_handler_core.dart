import 'dart:convert';
import 'response.dart';
import 'cache.dart';

class HttpHandlerCore {

  // Retrieve http headers
  dynamic getHeaders() async {
    String? token = await CacheAPI().getToken();

    if(token == null)
      return {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

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
        return Result(data: jsonDecode(response.body), status: StatusResponse.OK);
      case 400:
        return Result(data: jsonDecode(response.body), status: StatusResponse.BAD_REQUEST);
      case 401:
      case 403:
        return Result(data: jsonDecode(response.body), status: StatusResponse.UNAUTHORIZED);
      case 404:
        return Result(data: response.body, status: StatusResponse.NOT_FOUND);
      case 408:
        return Result(data: response.body, status: StatusResponse.TIME_OUT);
      case 500:
      default:
        return Result(data: response.body, status: StatusResponse.SERVER_ERROR);
    }
  }

}