import 'dart:convert';
import 'dart:io';

import 'package:fabspin/Screens/bottomnavigation.dart';
import 'package:fabspin/Screens/contact_us.dart';
import 'package:fabspin/Screens/my_request.dart';
import 'package:fabspin/Screens/order_screen.dart';
import 'package:fabspin/Screens/pay_now.dart';
import 'package:fabspin/Screens/prize_list.dart';
import 'package:fabspin/Screens/promotions.dart';
import 'package:fabspin/Screens/request_pickup.dart';
import 'package:fabspin/Screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Screens/home_page.dart';
import '../Splash/splash_screen.dart';
import '../Urls/urls.dart';

class CustomDrawer extends StatefulWidget {

  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

int _currentIndex = 0;
int _activeDrawerIndex = 0;
String _userName = '';
String _address = '';
int? userId;
String? profileImg;
String _userEmail =
    'Sector 62 C Block Phase 2 Industrial Area Sector 62 Noida Uttar Pradesh';
late String   walletAmount = "0.00";

class _CustomDrawerState extends State<CustomDrawer> {
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? 'U S E R N A M E';
      //_userEmail = prefs.getString('email') ?? 'Sector 62 C Block Phase 2 Industrial Area Sector 62 Noida Uttar Pradesh';
      _address = prefs.getString('userAddress') ?? 'Address';
      userId = prefs.getInt('user_id');
      profileImg = prefs.getString('profileImg');
      print("_userName ... ${_userName}");
      print("_userEmail ... ${_userEmail}");
      print("_userAddress ... ${_address}");
      print("_userID ... ${userId}");
    });
  }

  Future<void> getWallet() async {
    final url = Uri.parse('https://fabspin.org/api/get-wallet/${userId}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        walletAmount = responseData['total_amount'].toString();
      });
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('wallet', walletAmount);

      print("Wallet Amount ${walletAmount.toString()}");
    }
  }

  Future<void> _getUser() async {
    final url = Uri.parse(Urls.getUser);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': userId,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("responseData   $responseData");
        if (responseData['Status'] == 'Success') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'userAddress',
            responseData['customer']['house'] +
                ', ' +
                responseData['customer']['landmark'] +
                ', ' +
                responseData['customer']['address'],
          );
          print(responseData['customer']['address']);
          print(prefs.getString('userAddress'));
          await prefs.setString('userGst', responseData['customer']['customer_gst']);
          await prefs.setString('profileImg',
              "https://fabspin.org/public/${responseData['customer']['profilepic']}");


          await prefs.setString('userLat', responseData['customer']['lat']);
          await prefs.setString('userLong', responseData['customer']['long']);

          // Reload the user data to update the UI
          setState(() {
            _loadUserData();
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
    _loadUserData();
    getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16.0,
      shadowColor: Colors.black.withOpacity(0.3),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 30,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: profileImg != null && profileImg!.isNotEmpty
                            ? Image.network(
                          profileImg!,
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        )
                            : Image.asset(
                          'assets/images/Fabspin.png',  // Add a local default image in assets
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        ),
                      ),
                    ),

                    // const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 15,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              _address,
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.6),
                                letterSpacing: 1,
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              "Wallet: Rs. ${walletAmount}" ?? "0.00",
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Ionicons.home_outline,
              title: 'Home',
              index: 0,
              isActive: _activeDrawerIndex == 0,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 0;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Bottomnavigation()),
                );
              },
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Icons.announcement_outlined,
              title: 'Promotions & Offers',
              index: 1,
              isActive: _activeDrawerIndex == 1,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 1;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Promotions()),
                );
              },
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Icons.delivery_dining_outlined,
              title: 'Request Pickup',
              index: 2,
              isActive: _activeDrawerIndex == 2,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 2;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RequestPickup()),
                );
              },
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Ionicons.bag_handle_outline,
              title: 'My Requests',
              index: 3,
              isActive: _activeDrawerIndex == 3,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 3;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyRequest()),
                );
              },
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Ionicons.cube_outline,
              title: 'My Orders',
              index: 4,
              isActive: _activeDrawerIndex == 4,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 4;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderScreen()),
                );
              },
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Icons.currency_rupee_outlined,
              title: 'Pay  Now',
              index: 5,
              isActive: _activeDrawerIndex == 5,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 5;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PayNow()),
                );
              },
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Ionicons.pricetags_outline,
              title: 'Price  List',
              index: 6,
              isActive: _activeDrawerIndex == 6,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 6;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrizeList()),
                );
              },
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Ionicons.mail_open_outline,
              title: 'Contact Us',
              index: 7,
              isActive: _activeDrawerIndex == 7,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 7;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUs()),
                );
              },
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Ionicons.cog_outline,
              title: 'Settings',
              index: 8,
              isActive: _activeDrawerIndex == 8,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 8;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Setting()),
                );
              },
            ),
            Divider(color: Colors.black.withOpacity(0.4), height: 1),
            _buildMenuItem(
              icon: Ionicons.log_out_outline,
              title: 'Logout ',
              index: 9,
              isActive: _activeDrawerIndex == 9,
              onTap: () {
                setState(() {
                  _activeDrawerIndex = 9;
                });
                _handleLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildMenuItem({
  required IconData icon,
  required String title,
  required int index,
  required bool isActive,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : Colors.black,
                  letterSpacing: 1,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
