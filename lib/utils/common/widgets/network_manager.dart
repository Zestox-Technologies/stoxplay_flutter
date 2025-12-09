import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';



///
/// This class checks if device has internet connectivity or not
///
class NetworkManager {
  final StreamController<bool?> _onInternetConnected = StreamController.broadcast();

  Stream<bool?> get internetConnectionStream => _onInternetConnected.stream;

  Connectivity connectivity = Connectivity();

  bool? _isInternetConnected;

  Future<void> initialiseNetworkManager() async {
    final List<ConnectivityResult> result = await connectivity.checkConnectivity();
    _checkStatus(result.first);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result.first);
    });
  }

  Future<bool> isConnected() async {
    final List<ConnectivityResult> result = await connectivity.checkConnectivity();
    return _checkStatus(result.first);
  }

  Future<bool> _checkStatus(ConnectivityResult result) async {
    bool isInternet = false;
    switch (result) {
      case ConnectivityResult.wifi:
        isInternet = true;
        break;
      case ConnectivityResult.mobile:
        isInternet = true;
        break;
      case ConnectivityResult.ethernet:
        isInternet = true;
        break;
      case ConnectivityResult.none:
        isInternet = false;
        break;
      default:
        isInternet = false;
        break;
    }
    if (isInternet) isInternet = await _updateConnectionStatus();
    if (_isInternetConnected == null || _isInternetConnected != isInternet) {
      _isInternetConnected = isInternet;
      _onInternetConnected.sink.add(isInternet);
    }
    return isInternet;
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected = false;
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }

  Future<Future> disposeStream() async => _onInternetConnected.close();
}