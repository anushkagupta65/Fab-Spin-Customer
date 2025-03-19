import 'package:fabspin/Screens/home_page.dart';
import 'package:fabspin/Screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int _selectedIndex = 0; // This variable tracks the selected tab index
  final List<Widget> _pages = [
    Home(),    // 0: Home
    Setting(),  // 1: Settings
  ];

  void _onItemTapped(int index) {
    if (index == 0 || index == 1) {
      // For the first and second items, navigate to the corresponding page
      setState(() {
        _selectedIndex = index; // Update the selected index
      });
    } else if (index == 2) {
      // Call function for the third item (call)
      call();
    } else if (index == 3) {
      // Call function for the fourth item (WhatsApp)
      openWhatsApp();
    }
  }

  Future<void> openWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/7011744407');
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: GoogleFonts.sourceSans3(
        fontWeight: FontWeight.w500,
        color: Colors.grey,
        letterSpacing: 1,
        fontSize: 12,
        //fontWeight: FontWeight.bold,
      ),
        unselectedLabelStyle: GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          letterSpacing: 1,
          fontSize: 12,
          //fontWeight: FontWeight.bold,
        ),
        unselectedIconTheme: IconThemeData(color: Colors.white),
        selectedIconTheme: IconThemeData(color: Colors.grey),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.call_outline),
            label: 'Call',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.logo_whatsapp),
            label: 'WhatsApp',
          ),
        ],
        currentIndex: _selectedIndex, // Current selected index
        onTap: _onItemTapped, // Handle taps
        type: BottomNavigationBarType.fixed, // Optional: to fix the item count
      ),
      body: _pages[_selectedIndex], // Show the selected page
    );
  }
}
