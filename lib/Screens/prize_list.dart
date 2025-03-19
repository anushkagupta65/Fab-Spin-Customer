import 'dart:convert';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import '../Urls/urls.dart';
import '../tabs/custom_drawer.dart';
import 'notificaton_screen.dart';

class PrizeList extends StatefulWidget {
  const PrizeList({super.key});

  @override
  State<PrizeList> createState() => _PrizeListState();
}

class _PrizeListState extends State<PrizeList> {
  List<dynamic> priceList = [];
  List<dynamic> uniqueSubtrades = [];
  List<dynamic> filteredClothes = [];
  List<dynamic> serviceName = [];
  String? selectedSubtrade;
  String? selectedService; // Add this variable

  Future<void> getPrize() async {
    final response = await http.get(Uri.parse(Urls.priceList));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        priceList = jsonData;
        serviceName = priceList
            .map((price) => price["service_name"])
            .toSet()
            .toList();
      });
      if (serviceName.isNotEmpty) {
        selectedService = serviceName[0];
        filterClothesByService(selectedService!); // Automatically filter by the first service
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPrize();
  }

  // Filter categories based on selected service
  void filterClothesByService(String service) {
    setState(() {
      selectedService = service;

      // Filter uniqueSubtrades based on selected service
      uniqueSubtrades = priceList
          .where((price) => price["service_name"] == service)
          .map((price) => price["category"])
          .toSet()
          .toList();

      // Automatically select the first category if available
      if (uniqueSubtrades.isNotEmpty) {
        selectedSubtrade = uniqueSubtrades[0];
        filterClothesBySubtrade(selectedSubtrade!);
      } else {
        filteredClothes = []; // Clear filtered clothes if no categories are found
      }
    });
  }

  // Filter clothes based on selected service and category
  void filterClothesBySubtrade(String subtradeName) {
    setState(() {
      selectedSubtrade = subtradeName;
      filteredClothes = priceList
          .where((price) =>
      price["service_name"] == selectedService &&
          price["category"] == subtradeName)
          .toList();
    });
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
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          Badge(
            backgroundColor: Colors.grey,
            label: Text(walletAmount.substring(0, walletAmount.length - 3), style: TextStyle(color: Colors.white)),
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
          SizedBox(width: 20),
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
          SizedBox(width: 10),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: serviceName.length,
                itemBuilder: (context, index) {
                  final service = serviceName[index];
                  bool isSelected = service == selectedService;
                  return GestureDetector(
                    onTap: () {
                      filterClothesByService(service);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey : Colors.black,
                        border: Border.all(color: Colors.white),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          service,
                          style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: uniqueSubtrades.length,
                itemBuilder: (context, index) {
                  final subtrade = uniqueSubtrades[index];
                  bool isSelected = subtrade == selectedSubtrade;
                  return GestureDetector(
                    onTap: () {
                      filterClothesBySubtrade(subtrade);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey : Colors.black,
                        border: Border.all(color: Colors.white),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          subtrade,
                          style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredClothes.length,
                itemBuilder: (context, index) {
                  final clothe = filteredClothes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, ),
                    child: Container(
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        //border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              clothe["item_name"] ?? 'N/A',
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 13,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Rs. ${clothe["min_price"] ?? ''} - ${clothe["max_price"]}",
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 13,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

