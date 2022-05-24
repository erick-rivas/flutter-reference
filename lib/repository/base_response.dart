class BaseResponse<T> {

  Status status;
  T? data;
  String? message;

  BaseResponse.initial(this.message) : status = Status.INITIAL;

  BaseResponse.loading(this.message) : status = Status.LOADING;

  BaseResponse.completed(this.data) : status = Status.COMPLETED;

  BaseResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }

}

enum Status { INITIAL, LOADING, COMPLETED, ERROR }