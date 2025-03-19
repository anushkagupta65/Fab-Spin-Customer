import 'dart:convert';

import 'package:fabspin/Screens/schedule_pickup.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:fabspin/tabs/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:scroll_to_animate_tab/scroll_to_animate_tab.dart';
import 'package:http/http.dart' as http;

import '../Urls/urls.dart';
import '../tabs/service_card.dart';
import 'notificaton_screen.dart';

class ServiceDetails extends StatefulWidget {
  final position;
  const ServiceDetails({super.key, required int  this.position});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

List<Map<String, dynamic>> serviceNames = [];

class _ServiceDetailsState extends State<ServiceDetails> {
  @override
  void initState() {
    super.initState();
    fetchServices();
    print(widget.position);
  }

  Future<void> fetchServices() async {
    final response = await http.get(Uri.parse(Urls.services));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Services Data: ${jsonData}");
      setState(() {
        serviceNames = List<Map<String, dynamic>>.from(jsonData['services']);
        print("Service Names List: $serviceNames");
      });
    } else {
      print("Failed to load services. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Badge(
            backgroundColor: Colors.cyan,
            label: Text(walletAmount.substring(0, walletAmount.length -3), style: TextStyle(color: Colors.white),),
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
          SizedBox(width: 20,),
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
          SizedBox(width: 10,)
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'FABSPIN',
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: serviceNames.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator while data is being fetched
          : Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.09,
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),),
            child: ScrollToAnimateTab(
                activeTabDecoration: TabDecoration(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      border: Border.all(color: Colors.yellow),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                ),
                inActiveTabDecoration: TabDecoration(
                  textStyle: const TextStyle(color: Colors.black),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                ),
                tabs: [
                  ScrollableList(
                    label: serviceNames.isNotEmpty
                        ? serviceNames[0]['name']
                        : "Loading..",
                    body: Column(
                      children: [
                        ServiceCard(
                          title: serviceNames.isNotEmpty
                              ? serviceNames[0]['name']
                              : "Loading..",
                          subtitle: 'your clothes will dryclean',
                          imgUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3x1CNEXNbjThD_W_HIr8aKpGz2N_CBKYHBQ&s',
                          onClick: () {
                            if (serviceNames.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SchedulePickup(
                                        id: serviceNames[0]['id'])),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  ScrollableList(
                    label: serviceNames.isNotEmpty && serviceNames.length > 1
                        ? serviceNames[1]['name']
                        : "Loading..",
                    body: ServiceCard(
                      title: serviceNames.isNotEmpty && serviceNames.length > 1
                          ? serviceNames[1]['name']
                          : "Loading..",
                      subtitle: 'your clothes will dryclean',
                      imgUrl:
                          'https://images.pexels.com/photos/292999/pexels-photo-292999.jpeg?cs=srgb&dl=pexels-goumbik-292999.jpg&fm=jpg',
                      onClick: () {
                        if (serviceNames.length > 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SchedulePickup(id: serviceNames[1]['id'])),
                          );
                        }
                      },
                    ),
                  ),
                  ScrollableList(
                    label: serviceNames.isNotEmpty && serviceNames.length > 2
                        ? serviceNames[2]['name']
                        : "Loading..",
                    body: Column(
                      children: [
                        ServiceCard(
                          title:
                              serviceNames.isNotEmpty && serviceNames.length > 2
                                  ? serviceNames[2]['name']
                                  : "Loading..",
                          subtitle: 'your clothes will dryclean',
                          imgUrl:
                              'https://images.pexels.com/photos/53422/ironing-iron-press-clothing-53422.jpeg',
                          onClick: () {
                            if (serviceNames.length > 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SchedulePickup(
                                        id: serviceNames[2]['id'])),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 350,)
                      ],
                    ),
                  ),
                ],
              ),
          ),
    );
  }
}
