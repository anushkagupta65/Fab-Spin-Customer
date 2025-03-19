import 'dart:convert';

import 'package:fabspin/Screens/schedule_pickup.dart';
import 'package:fabspin/Screens/service_details.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import '../Urls/urls.dart';
import '../tabs/custom_drawer.dart';
import 'notificaton_screen.dart';

class RequestPickup extends StatefulWidget {
  const RequestPickup({super.key});

  @override
  State<RequestPickup> createState() => _RequestPickupState();
}

List<Map<String, dynamic>> serviceNames = [];

class _RequestPickupState extends State<RequestPickup> {
  @override
  void initState() {
    super.initState();

    //_loadUserData();
    fetchServices();
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


  List<Map<String, dynamic>> serviceImage = [
    {
      'imageUrl': 'assets/icon/dry-clean-icon.png',
    },
    {
      'imageUrl': 'assets/icon/shoe-cleaning-icon.png',
    },

    {
      'imageUrl': 'assets/icon/steam-iron-icon.png',
    },



  ];

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
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          Badge(
            backgroundColor: Colors.grey,
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
      ),
      drawer: CustomDrawer(),
      body: Container(
        color: Colors.white,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
                      itemCount: serviceNames.length,
                      itemBuilder: (BuildContext context, index) {
                        final service = serviceNames[index];
                        final finalserv = service['name'].toString();
                        final image = service['image'];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 3,
                                //offset: Offset(0, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(19.0),
                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context    ) =>  SchedulePickup(
                                    id: service['id'])),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image.asset(
                                //   serviceIcons[index],
                                //   width: 60,
                                //   height: 60,
                                // ),
                                Expanded(
                                  child: Image.asset(
                                    serviceImage[index]['imageUrl'].toString(),
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                                // Image.network(image,width: 120,
                                //   height: 120,),
                                const SizedBox(height: 8.0),
                                Text(
                                  //serviceNames[index].toString(),
                                  finalserv,
                                  style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontSize: 15,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 5,)
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: InkWell(
            //     onTap: (){},
            //     child: Container(
            //       child: Center(
            //           child:
            //               Text('Proceed', style: TextStyle(color: Colors.white))),
            //       height: 60,
            //       color: Colors.black,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
