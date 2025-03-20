import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Future<bool> checkConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  print("Connectivity Result: $connectivityResult");
  if (connectivityResult == ConnectivityResult.none) {
    print("No Internet Connection false");
    return false;
  } else {
    print("No Internet Connection true");
    return true;
  }
}

void showSnackBarView(
    BuildContext context, String message, Color backGroundColor) {
  SnackBar snackBarContent = SnackBar(
    content: Text(
      message,
      style: TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
    ),
    backgroundColor: backGroundColor,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100, right: 20, left: 20),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBarContent);
}
