import 'dart:convert';

import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Urls/urls.dart';
import '../tabs/custom_drawer.dart';
import 'package:http/http.dart' as http;

import 'notificaton_screen.dart';

class MyRequest extends StatefulWidget {
  MyRequest({super.key});

  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> with SingleTickerProviderStateMixin {
  TabController? tabController;
  int? userId;
  List<dynamic> pickups = [];
  List<dynamic> dropoffs = [];

  String dryCleanImg = 'https://fabspin.org/public/assets/images/dry-clean-icon.png';
  String shoeCleanImg = 'https://fabspin.org/public/assets/images/shoe-cleaning-icon.png';
  String steamIronImg = 'https://fabspin.org/public/assets/images/steam-iron-icon.png';

  Future<void> _myRequest() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    print(userId);
    final url = Uri.parse(Urls.pickUps);
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
          setState(() {
            pickups = responseData['bookings'];
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  Future<void> _myDropOffs() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    print("User ID: $userId");
    final url = Uri.parse("https://fabspin.org/api/get-drop/${userId}");
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Response Data: $responseData");

        // Check if the response contains data and update UI
        if (responseData['status'] == 'success') {
          setState(() {
            dropoffs = responseData['data'];
          });
          print('Drop-offs updated: ${dropoffs.length}');
        } else {
          print('No drop-offs found or status is not "Success"');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> _myRequestDlt(int booking_id) async {
    final url = Uri.parse(Urls.cancelPickUps);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'booking_id': booking_id,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("responseData   $responseData");
        if (responseData['Status'] == 'Success') {
          _myRequest(); // Refresh the list after cancellation
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    _myRequest();
    _myDropOffs();
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
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
          ),
        ),
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
          children: [
            TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              dividerColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey, Colors.black],
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.redAccent,
              ),
              controller: tabController,
              tabs: [
                Tab(text: 'PICKUPS'),
                Tab(text: 'DROP OFFS'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  ListView.builder(
                    itemCount: pickups.length,
                    itemBuilder: (BuildContext context, index) {
                      final pickup = pickups[index];
                      final bookingId = pickup['id'];
                      final status = pickup['status']; // Get the status
                      final service = pickup['services'] != null && pickup['services'].isNotEmpty
                          ? pickup['services'][0]
                          : 'Not Found';
                      final riderName = pickup['rider_name'] ?? 'Not Found';


                      String imgUrl;
                      if (service == 'Dry Clean') {
                        imgUrl = dryCleanImg;
                      } else if (service == 'Shoe Cleaning') {
                        imgUrl = shoeCleanImg;
                      } else if (service == 'Steam Iron') {
                        imgUrl = steamIronImg;
                      } else {
                        imgUrl = 'https://media.istockphoto.com/id/1055079680/vector/black-linear-photo-camera-like-no-image-available.jpg?s=612x612&w=0&k=20&c=P1DebpeMIAtXj_ZbVsKVvg-duuL0v9DlrOZUvPG6UJk='; // Default case if service doesn't match
                      }

                      return _myPickups(
                        service: pickup['services'] != null && pickup['services'].isNotEmpty
                      ? pickup['services'][0]
                          : 'Not Found',
                        bookingCode: pickup['booking_code'],
                        pickupDate: pickup['pickup_date'],
                        pickupTime: pickup['pickup_time'] != null && pickup['pickup_time'].isNotEmpty
                            ? pickup['pickup_time']
                            : 'Not Found',
                        bookingDate: pickup['rider_name'] ?? 'Not Found',
                        status: status,
                        onClick: () {
                          if (status == 1) {
                            _myRequestDlt(bookingId);
                          }
                        }, imgUrl: imgUrl,
                      );
                    },
                  ),







              dropoffs.isEmpty
                  ? Center(child: Text("No drop-offs found")) // Empty state
                  : ListView.builder(
                itemCount: dropoffs.length,
                itemBuilder: (BuildContext context, index) {
                  final pickup = dropoffs[index];
                  final service = pickup['service_name'] ?? 'Not Found';

                  print('Drop length in UI: ${dropoffs.length}'); // Debugging

                  final bookingCode = pickup['booking_code'] ?? 'Not Found';
                  final bookingDate = pickup['booking_date'] ?? 'Not Found';
                  final dropDate = pickup['drop_date'] ?? 'Not Found';
                  final dropTime = pickup['drop_time'] ?? 'Not Found';
                  final riderName = pickup['rider_name'] ?? 'Not Found';

                  String imgUrl;
                  if (service == 'Dryclean') {
                    imgUrl = dryCleanImg;
                  } else if (service == 'Shoe Cleaning') {
                    imgUrl = shoeCleanImg;
                  } else if (service == 'Steam Iron') {
                    imgUrl = steamIronImg;
                  } else {
                    imgUrl = 'https://media.istockphoto.com/id/1055079680/vector/black-linear-photo-camera-like-no-image-available.jpg?s=612x612&w=0&k=20&c=P1DebpeMIAtXj_ZbVsKVvg-duuL0v9DlrOZUvPG6UJk='; // Default image
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 15),
                          Container(
                            width: 80,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.network(imgUrl),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service,
                                style: GoogleFonts.sourceSans3(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                  letterSpacing: 1,
                                  fontSize: 15,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Booking Code: $bookingCode", style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
                              ),),
                              //Text("Booking Date: $bookingDate"),
                              Text("Drop Date: $dropDate", style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
                              ),),
                              Text("Drop Time: $dropTime", style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
                              ),),
                              Text("Rider Name: $riderName", style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )


              ],
              ),
            ),














          ],
        ),
      ),
    );
  }
}

Widget _myPickups({
  required String service,
  required String bookingCode,
  required String pickupDate,
  required String pickupTime,
  required String bookingDate,
  required int status,
  required String imgUrl,
  required final VoidCallback onClick,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 15, ),
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.network(imgUrl),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service,
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                  letterSpacing: 1,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              Text("Booking Code: $bookingCode",style: GoogleFonts.sourceSans3(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 1,
                fontSize: 12,
                //fontWeight: FontWeight.bold,
              ),),
              Text("Rider Name: $bookingDate",style: GoogleFonts.sourceSans3(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 1,
                fontSize: 12,
                //fontWeight: FontWeight.bold,
              ),),
              Text("Pickup Date: $pickupDate",style: GoogleFonts.sourceSans3(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 1,
                fontSize: 12,
                //fontWeight: FontWeight.bold,
              ),),
              Text("PickupTime: $pickupTime",style: GoogleFonts.sourceSans3(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 1,
                fontSize: 12,
                //fontWeight: FontWeight.bold,
              ),),
              status == 1
                  ? InkWell(
                onTap: onClick,
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Text(
                      "Cancel Pickup",
                      style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 12,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 15),
                child: Text(
                  "Cancelled Pickup",
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                    letterSpacing: 1,
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
