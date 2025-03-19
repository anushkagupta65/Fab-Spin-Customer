import 'package:fabspin/Screens/about_us.dart';
import 'package:fabspin/Screens/add_address.dart';
import 'package:fabspin/Screens/my_profile.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../tabs/custom_drawer.dart';
import 'contact_us.dart';
import 'notificaton_screen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Future<void> call() async {
    final Uri telUri = Uri(scheme: 'tel', path: '8588882929');

    // Request permission
    final status = await Permission.phone.request();

    if (status.isGranted) {
      try {
        if (await canLaunchUrl(telUri)) {
          await launchUrl(telUri);
        } else {
          throw 'Could not launch dialer';
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Phone permission denied');
    }
  }

  void _shareContent() {
    String text = 'Fabspin';
    String url =
        'https://play.google.com/store/apps/details?id=com.fabspin.drycleaners'; // Your link here
    Share.share('$text\n$url'); // Sharing both text and link
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
            child: Text(
          'FABSPIN',
          style: GoogleFonts.sourceSans3(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 20,
            //fontWeight: FontWeight.bold,
          ),
        )),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Badge(
            backgroundColor: Colors.grey,
            label: Text(
              walletAmount.substring(0, walletAmount.length - 3),
              style: TextStyle(color: Colors.white),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WalletHistory(),
                  ),
                );
              },
              child: Icon(Ionicons.wallet_outline, color: Colors.white),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: Icon(Ionicons.notifications_outline, color: Colors.white),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProfile()),
                );
              },
              child: ListTile(
                title: Text(
                  "My Profile",
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Ionicons.person_outline,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddAddress()),
                );
              },
              child: ListTile(
                title: Text(
                  "Add Address",
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Ionicons.location_outline,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const ContactUs()),
            //     );
            //   },
            //   child: ListTile(
            //     title: Text("Contact us"),
            //     leading: Icon(
            //       Ionicons.chatbox_ellipses_outline,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            // Divider(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUs()),
                );
              },
              child: ListTile(
                title: Text(
                  "About us",
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Ionicons.reader_outline,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                call();
              },
              child: ListTile(
                title: Text(
                  "Call us",
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Ionicons.call_outline,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                _shareContent();
              },
              child: ListTile(
                title: Text(
                  "Share",
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  Ionicons.share_outline,
                  color: Colors.black,
                ),
              ),
            ),
            // Divider(),
            // ListTile(
            //   title: Text("Delete Account"),
            //   leading: Icon(
            //     Icons.person,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
