class Result {

  final dynamic data;
  final StatusResponse status;

  Result({required this.data, required this.status});

  get getData => data;
  get getStatus => status;

}

enum StatusResponse { OK, INVALID_REQUEST, BAD_REQUEST, UNAUTHORIZED, NETWORK_ERROR, SERVER_ERROR, NOT_FOUND, TIME_OUT, UNKNOWN_ERROR }