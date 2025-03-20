import 'dart:math';
import 'package:fabspin/Screens/maps.dart';
import 'package:fabspin/Screens/notificaton_screen.dart';
import 'package:fabspin/Screens/promotions.dart';
import 'package:fabspin/Screens/schedule_pickup.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:fabspin/Urls/urls.dart';
import 'package:fabspin/tabs/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_details_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> serviceNames = [];
  List<dynamic> myOrders = [];
  List<dynamic> filteredOrders = [];

  int _currentIndex = 0;
  List<Map<String, dynamic>> banners = [
    {
      'imageUrl': 'assets/images/banner1.gif',
    },
    {
      'imageUrl': 'assets/images/banner3.jpeg',
    },
    {
      'imageUrl': 'assets/images/banner2.gif',
    },
  ];

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

  String _address = '';
  String? _storedAddress;
  TextEditingController _loc = TextEditingController();
  final keyIsFirstLoaded = 'is_first_loaded';
  int ItemCount = 5;

  String dryCleanImg =
      'https://fabspin.org/public/assets/images/dry-clean-icon.png';
  String shoeCleanImg =
      'https://fabspin.org/public/assets/images/shoe-cleaning-icon.png';
  String steamIronImg =
      'https://fabspin.org/public/assets/images/steam-iron-icon.png';

  @override
  void initState() {
    super.initState();
    CustomDrawer();
    fetchServices();
    _loadUserData();
    _getAddressFromPreferences();
    _myOrders();
    getWallet();
    Future.delayed(Duration(seconds: 10), () => showPromoFirstLoaded(context));
  }

  Future<void> getWallet() async {
    final url =
        Uri.parse('https://fabspin.org/api/get-wallet/${userId.toString()}');
    print(url);
    final response = await http.get(url);
    print(json.decode(response.body));
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

  Future<void> _getAddressFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedAddress = prefs.getString('userAddress') ?? 'No address found';
      _loc.text = _storedAddress ?? 'No address found';
    });
  }

  void _onAddressSelected(String address) {
    setState(() {
      _storedAddress = address;
      _loc.text = address;
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _address = prefs.getString('userAddress') ?? 'Loading...';
      print("_userAddress ... ${_address}");
      userId = prefs.getInt('user_id');
    });
    Future.delayed(Duration(seconds: 5), () => getWallet());
  }

  String getImageUrl(String serviceName) {
    switch (serviceName) {
      case 'Dryclean':
        return dryCleanImg;
      case 'Shoes/Bag Cleaning':
        return shoeCleanImg;
      case 'Steam Press':
        return steamIronImg;
      default:
        return 'https://media.istockphoto.com/id/1055079680/vector/black-linear-photo-camera-like-no-image-available.jpg?s=612x612&w=0&k=20&c=P1DebpeMIAtXj_ZbVsKVvg-duuL0v9DlrOZUvPG6UJk='; // Default case
    }
  }

  Future<void> _myOrders() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    print(userId);
    final url = Uri.parse(Urls.myOrders);
    try {
      final response = await http.post(url,
          body: json.encode({"customer_id": userId}),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {}
      final responseData = json.decode(response.body);
      print("responseData $responseData");
      if (responseData['Status'] == "Success") {
        setState(() {
          myOrders = responseData['order_report'];
          filteredOrders = myOrders
              .where((order) => order['status'] != 'Delivered')
              .toList();
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchServices() async {
    final response = await http.get(Uri.parse(Urls.services));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Services Data: ${jsonData}");
      setState(() {
        serviceNames = List<Map<String, dynamic>>.from(jsonData['services']);
        print("Service Names List: $serviceNames");
        _getAddressFromPreferences();
      });
    } else {
      print("Failed to load services. Status code: ${response.statusCode}");
    }
  }

  Future<void> showPromoFirstLoaded(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? isFirstLoaded = pref.getBool(keyIsFirstLoaded);
    List<String> promoImages = [
      'assets/images/promotion1.jpeg',
      'assets/images/promotion2.jpeg',
    ];

    if (isFirstLoaded == true) {
      var randomImage = promoImages[Random().nextInt(promoImages.length)];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Positioned(
                left: 80,
                bottom: 275,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 200,
                  width: 200,
                  child: Image.asset(randomImage),
                ),
              ),
              Positioned(
                right: 70,
                top: 275,
                child: IconButton(
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                    pref.setBool(keyIsFirstLoaded, false);
                  },
                  icon: Icon(Icons.cancel, color: Colors.black),
                ),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Icon(Icons.location_on, size: 15, color: Colors.white),
            SizedBox(width: 5),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MapScreen(onAddressSelected: _onAddressSelected),
                  ),
                );
              },
              child: SizedBox(
                width: 150,
                child: Text(
                  maxLines: 1,
                  _address,
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              SizedBox(width: 10),
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
                child:
                    Icon(Ionicons.notifications_outline, color: Colors.white),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ],
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 120.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 15),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      aspectRatio: 2.0,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: true,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: banners.asMap().entries.map((entry) {
                      int index = entry.key;
                      var banner = entry.value;
                      return GestureDetector(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SchedulePickup(id: 22),
                                ),
                              );
                              break;
                            case 1:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SchedulePickup(id: 22),
                                ),
                              );
                              break;
                            case 2:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Promotions(),
                                ),
                              );
                              break;
                            default:
                              print("No navigation for this banner");
                          }
                        },
                        child: ClipRRect(
                          child: Image.asset(
                            banner['imageUrl'].toString(),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: CarouselIndicator(
                      count: banners.length,
                      index: _currentIndex,
                      color: Colors.grey.withOpacity(0.45),
                      activeColor: Colors.black,
                      size: 8.0,
                      activeSize: 10.0,
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: ClipRRect(
                  child: Image.asset(
                      height: 61,
                      fit: BoxFit.cover,
                      'assets/images/bannersmall.gif'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'SERVICES',
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 2,
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: serviceNames.length,
                  itemBuilder: (context, index) {
                    final service = serviceNames[index];
                    final finalserv = service['name'].toString();
                    // final image = service['image'];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                          )
                        ],
                        borderRadius: BorderRadius.circular(19.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SchedulePickup(id: service['id'])),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                serviceImage[index]['imageUrl'].toString(),
                                width: 100,
                                height: 100,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              finalserv,
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'MY OPEN ORDERS',
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 2,
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),
                child: Divider(),
              ),
              const SizedBox(
                height: 10,
              ),
              filteredOrders
                      .where((order) => order['status'] != 'Delivered')
                      .isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsScreen(
                                id: filteredOrders[0]
                                    ['id'], // Access the first order's ID
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                              )
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 15, right: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${filteredOrders[0]['booking_code']}',
                                          style: GoogleFonts.sourceSans3(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            letterSpacing: 1,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          "${filteredOrders[0]['status']}",
                                          style: GoogleFonts.sourceSans3(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            letterSpacing: 1,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Balance Due : ${filteredOrders[0]['order_total_amount_due'].toString()}",
                                          style: GoogleFonts.sourceSans3(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            letterSpacing: 1,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            child: Text(
                                              'View',
                                              style: GoogleFonts.sourceSans3(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                letterSpacing: 1,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                      "No Orders, Create New Order",
                      style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    )),
              const SizedBox(
                height: 36,
              ),
              Text(
                'TRENDING SERVICES',
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 2,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: serviceNames.length,
                  itemBuilder: (context, index) {
                    final service = serviceNames[index];
                    final finalserv = service['name'].toString();
                    // final image = service['image'];
                    print(finalserv);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SchedulePickup(id: service['id'])),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 3,
                            )
                          ],
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                serviceImage[index]['imageUrl'].toString(),
                                width: 100,
                                height: 100,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              finalserv,
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CarouselIndicator extends StatelessWidget {
  final int count;
  final int index;
  final Color color;
  final Color activeColor;
  final double size;
  final double activeSize;

  const CarouselIndicator({
    super.key,
    required this.count,
    required this.index,
    this.color = Colors.grey,
    this.activeColor = Colors.black,
    this.size = 8.0,
    this.activeSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: i == index ? activeSize : size,
          height: i == index ? activeSize : size,
          decoration: BoxDecoration(
            color: i == index ? activeColor : color,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
