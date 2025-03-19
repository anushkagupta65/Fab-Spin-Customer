import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/PushNotificationService.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> _notifications = [];
  final PushNotificationService _notificationService = PushNotificationService();

  @override
  void initState() {
    super.initState();

    // Load saved notifications from SharedPreferences
    _loadSavedNotifications();

    // Initialize the notification service and update UI when notifications arrive
    _notificationService.initialize((List<NotificationModel> newNotifications) {
      if (mounted) {
        setState(() {
          _notifications = newNotifications; // Update notifications list
        });
      }
    });
  }

  // Load notifications from SharedPreferences
  Future<void> _loadSavedNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notificationsJson = prefs.getStringList('notifications');

    if (notificationsJson != null) {
      setState(() {
        _notifications = notificationsJson
            .map((n) => NotificationModel.fromMap(jsonDecode(n)))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    // Perform any necessary cleanup before the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Notifications", style: GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 1,
          fontSize: 20,
          //fontWeight: FontWeight.bold,
        ),),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        //),
        child: _notifications.isEmpty
            ? Center(child: Text("No notifications yet", style: GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          letterSpacing: 1,
          fontSize: 15,
          //fontWeight: FontWeight.bold,
        ),))
            : SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(_notifications[index].title),
                  subtitle: Text(_notifications[index].body),
                  leading: _notifications[index].imageUrl.isNotEmpty
                      ? Image.network(_notifications[index].imageUrl)
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
