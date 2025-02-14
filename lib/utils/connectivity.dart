import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtility {
  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile || 
           connectivityResult == ConnectivityResult.wifi;
  }
}