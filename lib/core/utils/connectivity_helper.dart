import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }

  static Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) => results.first);
  }
}
