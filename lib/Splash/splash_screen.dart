import 'package:fabspin/Screens/home_page.dart';
import 'package:fabspin/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import "package:fabspin/Urls/urls.dart";
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/bottomnavigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
  
    _checkLoginStatus();

  }

  _promo()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('is_first_loaded', true);
  }

  // Future<void> _checkLoginStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   print("isloggedIn ${isLoggedIn}");
  //   await Future.delayed(const Duration(seconds: 3), () {});
  //   if (isLoggedIn) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const Home()),
  //     );
  //   } else {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const LoginScreen()),
    //     );
  //   }
  // }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate splash screen delay

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId != null) {
      
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) =>  Home()),
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Bottomnavigation()),
      );
      _promo();
    } else {
      // User is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon/fabspinsplash.png", width: double.infinity, height: 300,)
            // Image.network(
            //   Urls.splashLogo,
            //   width: 300,
            //   height: 300,
            // ),
          ],
        ),
      ),
    );
  }
}
