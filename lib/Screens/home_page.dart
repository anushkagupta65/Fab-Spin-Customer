// hsfnsfj  fsfjksnfs nsfksddf

// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final List<String> imageUrls = [
//     'https://www.fabspin.com/wp-content/uploads/2024/06/Untitled-design-44.jpg',
//     'https://www.fabspin.com/wp-content/uploads/2024/06/Untitled-design-43.jpg',
//     'https://www.fabspin.com/wp-content/uploads/2024/06/Untitled-design-42.jpg',
//     'https://www.fabspin.com/wp-content/uploads/2024/06/Untitled-design-46.jpg',
//   ];

//   final List<String> serviceIcons = [
//     'assets/images/garment-cleaning.jpg',
//     'assets/images/shoe-cleaning.jpg',
//     'assets/images/carpet-cleaning.jpg',
//     'assets/images/sofa-cleaning.jpg',
//   ];

//   final List<String> serviceNames = [
//     'Garment Cleaning',
//     'Shoe Cleaning',
//     'Carpet Cleaning',
//     'Sofa Cleaning',
//     'Bag Cleaning',
//   ];

//   int _currentIndex = 0;
//   int _activeDrawerIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Home Page',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//       ),
//       drawer: SafeArea(
//         child: Drawer(
//           elevation: 16.0,
//           shadowColor: Colors.black.withOpacity(0.3),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 10,
//                 ),
//                  Padding(
//                    padding:  const EdgeInsets.only(left: 18.0, top: 5, bottom: 5),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       const CircleAvatar(
//                         backgroundColor: Colors.black,
//                         radius: 20,
//                       ),
//                       const SizedBox(width: 30),
//                       Text(
//                         'U S E R N A M E ',
//                         style: GoogleFonts.barlow(
//                             color: Colors.black, fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                 ),
//                 Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.home,
//                   title: 'H o m e',
//                   index: 0,
//                   isActive: _activeDrawerIndex == 0,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 0;
//                     });
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => const Home()),
//                     );
//                   },
//                 ),
//               Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.announcement_sharp,
//                   title: 'P u r c h a s e  &  O f f e r s',
//                   index: 1,
//                   isActive: _activeDrawerIndex == 1,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 1;
//                     });
//                   },
//                 ),
//             Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.delivery_dining,
//                   title: 'R e q u e s t  P i c k u p',
//                   index: 2,
//                   isActive: _activeDrawerIndex == 2,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 2;
//                     });
//                   },
//                 ),
//             Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.request_page,
//                   title: 'M y  R e q u e s t s',
//                   index: 3,
//                   isActive: _activeDrawerIndex == 3,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 3;
//                     });
//                   },
//                 ),
//               Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.book_online_outlined,
//                   title: 'M y  O r d e r s',
//                   index: 4,
//                   isActive: _activeDrawerIndex == 4,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 4;
//                     });
//                   },
//                 ),
//                 Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.currency_rupee,
//                   title: 'P a y  N o w',
//                   index: 5,
//                   isActive: _activeDrawerIndex == 5,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 5;
//                     });
//                   },
//                 ),
//              Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.credit_score,
//                   title: 'P r i c e  L i s t',
//                   index: 6,
//                   isActive: _activeDrawerIndex == 6,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 6;
//                     });
//                   },
//                 ),
//              Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.contact_mail_sharp,
//                   title: 'C o n t a c t   U s',
//                   index: 7,
//                   isActive: _activeDrawerIndex == 7,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 7;
//                     });
//                   },
//                 ),
//                   Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.settings,
//                   title: 'S e t t i n g s',
//                   index: 8,
//                   isActive: _activeDrawerIndex == 8,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 8;
//                     });
//                   },
//                 ),
//                    Divider(color: Colors.black.withOpacity(0.4),height: 1),
//                 _buildMenuItem(
//                   icon: Icons.logout,
//                   title: 'L o g O u t ',
//                   index: 9,
//                   isActive: _activeDrawerIndex == 9,
//                   onTap: () {
//                     setState(() {
//                       _activeDrawerIndex = 9;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: 250.0,
//                     autoPlay: true,
//                     autoPlayInterval: const Duration(seconds: 5),
//                     autoPlayAnimationDuration:
//                         const Duration(milliseconds: 800),
//                     autoPlayCurve: Curves.fastOutSlowIn,
//                     pauseAutoPlayOnTouch: true,
//                     aspectRatio: 2.0,
//                     viewportFraction: 1.0,
//                     enlargeCenterPage: true,
//                     enableInfiniteScroll: true,
//                     scrollDirection: Axis.horizontal,
//                     onPageChanged: (index, reason) {
//                       setState(() {
//                         _currentIndex = index;
//                       });
//                     },
//                   ),
//                   items: imageUrls.map((url) {
//                     return Container(
//                       margin: const EdgeInsets.all(8.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.network(
//                           url,
//                           fit: BoxFit.cover,
//                           width: 1000,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 Positioned(
//                   bottom: 30,
//                   left: 0,
//                   right: 0,
//                   child: CarouselIndicator(
//                     count: imageUrls.length,
//                     index: _currentIndex,
//                     color: Colors.grey.withOpacity(0.45),
//                     activeColor: Colors.black,
//                     size: 8.0,
//                     activeSize: 12.0,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//              Text(
//               'S E R V I C E S',
//               style: GoogleFonts.barlow(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 16.0,
//                   mainAxisSpacing: 16.0,
//                 ),
//                 itemCount: serviceIcons.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(19.0),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           serviceIcons[index],
//                           width: 60,
//                           height: 60,
//                         ),
//                         const SizedBox(height: 8.0),
//                         Text(
//                           serviceNames[index],
//                           style:  GoogleFonts.barlow(
//                             fontSize: 12.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//              Text(
//               'T R E N D I N G   S E R V I C E S',
//               style: GoogleFonts.barlow(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 16.0,
//                   mainAxisSpacing: 16.0,
//                 ),
//                 itemCount: serviceIcons.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black),
//                       borderRadius: BorderRadius.circular(19.0),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           serviceIcons[index],
//                           width: 60,
//                           height: 60,
//                         ),
//                         const SizedBox(height: 8.0),
//                         Text(
//                           serviceNames[index],
//                           style: GoogleFonts.barlow(
//                             fontSize: 12.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     required int index,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return Padding(
//         padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom: 10),
//       child: InkWell(
//         onTap: onTap,
//         child: Container(
//           height: 40,
//           decoration: BoxDecoration(
//              color: isActive ? Colors.black : Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//              padding: const EdgeInsets.only(left: 18.0, top: 5, bottom: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Icon(
//                   icon,
//                   color: isActive ? Colors.white : Colors.black,
//                 ),
//                 const SizedBox(width: 20),
//                 Text(
//                   title,
//                   style: GoogleFonts.barlow(
//                     color: isActive ? Colors.white : Colors.black,
//                     fontWeight: FontWeight.w400
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CarouselIndicator extends StatelessWidget {
//   final int count;
//   final int index;
//   final Color color;
//   final Color activeColor;
//   final double size;
//   final double activeSize;

//   const CarouselIndicator({
//     super.key,
//     required this.count,
//     required this.index,
//     this.color = Colors.grey,
//     this.activeColor = Colors.black,
//     this.size = 8.0,
//     this.activeSize = 12.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(count, (i) {
//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           margin: const EdgeInsets.symmetric(horizontal: 4.0),
//           width: i == index ? activeSize : size,
//           height: i == index ? activeSize : size,
//           decoration: BoxDecoration(
//             color: i == index ? activeColor : color,
//             shape: BoxShape.circle,
//           ),
//         );
//       }),
//     );
//   }
// }

// // new code with api to fetch banners defined on 4 sept 2024

import 'dart:math';

import 'package:fabspin/Screens/maps.dart';
import 'package:fabspin/Screens/notificaton_screen.dart';
import 'package:fabspin/Screens/promotions.dart';
import 'package:fabspin/Screens/schedule_pickup.dart';
import 'package:fabspin/Screens/service_details.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:fabspin/Urls/urls.dart';
import 'package:fabspin/tabs/custom_drawer.dart';
import 'package:fabspin/utils/PushNotificationService.dart';
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
  //int _activeDrawerIndex = 0;
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
  int ItemCount  = 5;

  String dryCleanImg =
      'https://fabspin.org/public/assets/images/dry-clean-icon.png';
  String shoeCleanImg =
      'https://fabspin.org/public/assets/images/shoe-cleaning-icon.png';
  String steamIronImg =
      'https://fabspin.org/public/assets/images/steam-iron-icon.png';



  @override
  void initState() {
    super.initState();
    //fetchBanners();
    CustomDrawer();
    fetchServices();
    _loadUserData();
    _getAddressFromPreferences();
    _myOrders();
    getWallet();
    //WidgetsBinding.instance.addPostFrameCallback(showPromoFirstLoaded(context));
    Future.delayed(Duration(seconds: 10), () => showPromoFirstLoaded(context));
  }


  Future<void> getWallet() async {
    final url = Uri.parse('https://fabspin.org/api/get-wallet/${userId.toString()}');
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

  // Future<void> fetchBanners() async {
  //   final response = await http.get(Uri.parse(Urls.getBanner));
  //   if (response.statusCode == 200) {
  //     print("${response.statusCode} response.statuscode hadhaf a ");
  //
  //     final jsonData = json.decode(response.body);
  //     setState(() {
  //       banners = List<Map<String, dynamic>>.from(jsonData['data']);
  //     });
  //   } else {
  //     throw Exception('Failed to load banners');
  //   }
  // }

  // Future<void> fetchServices() async {
  //   final response = await http.get(Uri.parse(Urls.services));
  //   if(response.statusCode == 200){
  //     //print("Services Status: ${response.statusCode}");
  //
  //     final jsonData = json.decode(response.body);
  //     print("Services Status: ${jsonData}");
  //     setState(() {
  //       serviceNames = List<Map<String, dynamic>>.from(jsonData["data"]);
  //       print("json data${serviceNames}");
  //     });
  //   }else{
  //     throw Exception('Failed to load Services');
  //   }
  // }

  String getImageUrl(String serviceName) {
    switch (serviceName) {
      case 'Dryclean':
        return dryCleanImg; // your dry clean image URL
      case 'Shoes/Bag Cleaning':
        return shoeCleanImg; // your shoe cleaning image URL
      case 'Steam Press':
        return steamIronImg; // your steam iron image URL
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
          filteredOrders = myOrders.where((order) => order['status'] != 'Delivered').toList();
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

    // List of promotional images from assets
    List<String> promoImages = [
      'assets/images/promotion1.jpeg',
      'assets/images/promotion2.jpeg',
    ];

    if (isFirstLoaded == true) {
      // Select a random image from the list
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
                  child: Image.asset(randomImage), // Load image from assets
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



  // Future<void> _handleLogout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const SplashScreen()),
  //   );
  // }

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
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Row(
        //       children: [
        //         Icon(Icons.location_on, size: 15, color: Colors.white),
        //         SizedBox(width: 5),
        //         InkWell(
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) =>
        //                     MapScreen(onAddressSelected: _onAddressSelected),
        //               ),
        //             );
        //           },
        //           child: Text(
        //             _address,
        //             style: TextStyle(color: Colors.white, fontSize: 12),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        actions: [

          Row(
            children: [
              // Icon(Icons.location_on, size: 15, color: Colors.white),
              // SizedBox(width: 5),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) =>
              //             MapScreen(onAddressSelected: _onAddressSelected),
              //       ),
              //     );
              //   },
              //   child: SizedBox(
              //     width: 180,
              //     child: Text(
              //       maxLines: 1,
              //       _address,
              //       style: GoogleFonts.sourceSans3(
              //         fontWeight: FontWeight.w500,
              //         color: Colors.white,
              //         letterSpacing: 1,
              //         fontSize: 12,
              //         //fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(width: 10),
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
        ],
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
        //     decoration: BoxDecoration(
        //     image: DecorationImage(
        // opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //     ),),
          child: Column(
            children: [
              //SizedBox(height: 10,),
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
                        onTap: (){
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
                          // Add more cases for additional banners
                            default:
                              print("No navigation for this banner");
                          }
                        },
                        child: ClipRRect(
                          //borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            //'${Urls.bannerUrl}${banner['image_url']}',
                            banner['imageUrl'].toString(),
                            fit: BoxFit.fitWidth,
                            //width: double.infinity,
                            //width: MediaQuery.of(context).size.width * 0.9,
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

              // const SizedBox(
              //   height: 20,
              // ),

              Container(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                //
                // ),
                width: double.infinity,
                //height: 90,
                child: ClipRRect(
                  //borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    height: 61,
                      fit: BoxFit.cover,
                    'assets/images/bannersmall.gif'
                  ),
                ),
              ),
              SizedBox(height: 10,),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       border: Border.all(color: Colors.black),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //         Text(
              //           'Wallet Amount : ',
              //           style:
              //           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //         ),
              //         Text(
              //           'Rs. ${walletAmount}',
              //           style:
              //           TextStyle(fontSize: 18, ),
              //         ),
              //       ],),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10,),

              Text(
                'SERVICES',
                style: GoogleFonts.sourceSans3(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 2,
                fontSize: 15,
                //fontWeight: FontWeight.bold,
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
                  itemCount:serviceNames.length,
                  //serviceIcons.length,
                  itemBuilder: (context, index) {
                    final service = serviceNames[index];
                    final finalserv = service['name'].toString();
                    final image = service['image'];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            //offset: Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(19.0),
                      ),
                      child: InkWell(
                        onTap: (){
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => ServiceDetails(position: index)),
                              // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SchedulePickup(
                                    id: service['id'])),
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
                            // Expanded(
                            //   child: Image.network(image,width: 100,
                            //    height: 100,),
                            // ),
                            const SizedBox(height: 8.0),
                            Text(
                              //serviceNames[index].toString(),
                              finalserv,
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
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
                  //fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),
                child: Divider(),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 40, right: 40, top: 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       InkWell(
              //         onTap: (){},
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
              //           child: Padding(
              //             padding: const EdgeInsets.all(12),
              //             child: Text('Order Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),),
              //           ),
              //         ),
              //       ),
              //       InkWell(
              //         onTap: (){},
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.white,
              //               borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black)),
              //           child: Padding(
              //             padding: const EdgeInsets.all(12),
              //             child: Text('Order Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              const SizedBox(height: 10,),
              filteredOrders.where((order) => order['status'] != 'Delivered').isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(
                          id: filteredOrders[0]['id'], // Access the first order's ID
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
                          //offset: Offset(0, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Padding(
                        //   padding: const EdgeInsets.all(15),
                        //   child: Image.network(
                        //     getImageUrl(filteredOrders[0]['service_name']),
                        //     width: 70,
                        //     height: 70,
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${filteredOrders[0]['service_name']}',
                                    style: GoogleFonts.sourceSans3(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      "${filteredOrders[0]['status']}",  style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontSize: 12,
                                    //fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                              // Text(
                              //     "Booking Code : ${filteredOrders[0]['booking_code'].toString()}"),
                              //
                              // SizedBox(height: 5),
                              //
                              // Text(
                              //     "Drop Date : ${filteredOrders[0]['drop_date']}"),
                              // SizedBox(height: 5),
                              // Text(
                              //     "Gross Amount : Rs. ${filteredOrders[0]['order_total_before_tax'].toString()}"),
                              // SizedBox(height: 5),
                              // Text(
                              //     "Net Amount : Rs. ${filteredOrders[0]['order_total_after_tax'].toString()}"),
                              // SizedBox(height: 5),
                              // Text(
                              //     "Paid Amount : ${filteredOrders[0]['order_amount_paid'].toString()}"),
                              // SizedBox(height: 5),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Text(
                                    "Balance Due : ${filteredOrders[0]['order_total_amount_due'].toString()}",  style: GoogleFonts.sourceSans3(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  letterSpacing: 1,
                                  fontSize: 12,
                                  //fontWeight: FontWeight.bold,
                                ),),
                                Container(
                                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    child: Text('View',  style: GoogleFonts.sourceSans3(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontSize: 12,
                                      //fontWeight: FontWeight.bold,
                                    ),),
                                  ),
                                )
                              ],)
                            ],
                          ),
                        ),
                        //SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              )
                  : Center(child: Text("No Orders, Create New Order", style: GoogleFonts.sourceSans3(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 1,
                fontSize: 12,
                //fontWeight: FontWeight.bold,
              ),)),


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
                  //fontWeight: FontWeight.bold,
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
                  //serviceIcons.length,
                  itemBuilder: (context, index) {
                    final service = serviceNames[index];
                    final finalserv = service['name'].toString();
                    final image = service['image'];
                    print(finalserv);
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SchedulePickup(
                                  id: service['id'])),
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
                              //offset: Offset(0, 3),
                            )
                          ],
                          //border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(19.0),
                        ),
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
                                width: 100,
                                height: 100,
                              ),
                            ),
                            // Expanded(
                            //   child: Image.network(image,width: 100,
                            //     height: 100,),
                            // ),
                            const SizedBox(height: 8.0),
                            Text(
                              finalserv,
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 12,
                                //fontWeight: FontWeight.bold,
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
              SizedBox(height: 50,)
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



