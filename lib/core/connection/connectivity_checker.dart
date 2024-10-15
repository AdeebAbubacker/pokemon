import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityChecker {
  Future<bool> hasInternetAccess() async {
    // Check connectivity type
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No internet connection
    }

    // Perform a simple network request to verify internet access
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode == 200; // Successful response means internet access
    } on SocketException {
      return false; // Network error
    }
  }
}