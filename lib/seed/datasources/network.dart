import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../api.dart';
import '../gql.dart';

enum NetworkStatus { ONLINE, OFFLINE }

class NetworkStatusService {

  StreamController<NetworkStatus> networkStatusController = StreamController<NetworkStatus>();

  init() {
    Connectivity().onConnectivityChanged.listen((status) {
      var networkStatus = _getNetworkStatus(status);
      if(networkStatus == NetworkStatus.ONLINE) {
        HttpHandler().retryFailedRequests();
        GraphQL().retryFailedRequests();
      }
      networkStatusController.add(_getNetworkStatus(status));
    });
  }

  NetworkStatus _getNetworkStatus(ConnectivityResult status) =>
    status == ConnectivityResult.mobile || status == ConnectivityResult.wifi ?
      NetworkStatus.ONLINE : NetworkStatus.OFFLINE;

}