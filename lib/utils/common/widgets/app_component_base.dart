import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:stoxplay/utils/common/widgets/no_internet_dialog.dart';

class AppComponentBase {
  static final AppComponentBase _instance = AppComponentBase._internal();
  factory AppComponentBase() => _instance;
  AppComponentBase._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  bool _isDialogShowing = false;

  Future<void> init() async {
    await _checkInitialConnectivity();
    _initConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      _showNoInternetDialog();
    }
  }

  void _initConnectivity() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        _showNoInternetDialog();
      } else {
        _hideNoInternetDialog();
      }
    });
  }

  void _showNoInternetDialog() {
    if (!_isDialogShowing && navigatorKey.currentContext != null) {
      _isDialogShowing = true;
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => NoInternetDialog(
          onRetry: () {
            _hideNoInternetDialog();
            _checkConnectivity();
          },
        ),
      );
    }
  }

  void _hideNoInternetDialog() {
    if (_isDialogShowing && navigatorKey.currentContext != null) {
      _isDialogShowing = false;
      Navigator.of(navigatorKey.currentContext!).pop();
    }
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showNoInternetDialog();
    }
  }

  // Public method to check connectivity from anywhere in the app
  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
} 