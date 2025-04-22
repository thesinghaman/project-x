import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Service for managing network connectivity
class ConnectivityManager extends GetxService {
  final RxBool isConnected = false.obs;
  final Rx<ConnectivityResult> connectionType = ConnectivityResult.none.obs;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<ConnectivityManager> init() async {
    await checkConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    return this;
  }

  Future<bool> checkConnectivity() async {
    final resultList = await _connectivity.checkConnectivity();
    _updateConnectionStatus(resultList);
    return isConnected.value;
  }

  void _updateConnectionStatus(List<ConnectivityResult> resultList) {
    // The list is guaranteed to be non-empty, use the first element
    final result = resultList.first;

    connectionType.value = result;
    isConnected.value = result != ConnectivityResult.none;
  }

  String getConnectionTypeString() {
    switch (connectionType.value) {
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown';
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
