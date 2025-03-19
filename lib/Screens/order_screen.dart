import 'dart:convert';

import 'package:fabspin/Screens/booking_confirmation.dart';
import 'package:fabspin/Screens/order_details_screen.dart';
import 'package:fabspin/Screens/order_tracking_page.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Urls/urls.dart';
import '../components/app_components.dart';
import '../tabs/custom_drawer.dart';
import 'notificaton_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  //int? userId;
  List<dynamic> myOrders = [];
  List<dynamic> deliveredOrders = [];
  List<dynamic> filteredOrders = [];
  String selectedFilter = 'Orders';
  final Razorpay _razorpay = Razorpay();
  final _razorpayKey = "rzp_live_f6t7NV0566alc2";
  late var price = 0;
  late var bookingid;
  late var bookingcode;
  int totalamount = 0;
  String _email = '';
  String _mobiie = '';
  String dryCleanImg =
      'https://fabspin.org/public/assets/images/dry-clean-icon.png';
  String shoeCleanImg =
      'https://fabspin.org/public/assets/images/shoe-cleaning-icon.png';
  String steamIronImg =
      'https://fabspin.org/public/assets/images/steam-iron-icon.png';


  Future<void> getAmount() async {
    final url = Uri.parse('https://fabspin.org/api/pending-amount/${userId}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        totalamount = responseData['pending_amount'];
      });

      print(responseData);

      print("total Amount ${totalamount.toString()}");
    }
  }

  // Future<void> getWallet() async {
  //   final url = Uri.parse('https://fabspin.org/api/get-wallet/${userId}');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     setState(() {
  //       walletAmount = responseData['total_amount'].toString();
  //     });
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     await pref.setString('wallet', walletAmount);
  //
  //     print("Wallet Amount ${walletAmount.toString()}");
  //   }
  // }


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
           deliveredOrders = myOrders.where((order) => order['status'] == 'Delivered').toList();
           filteredOrders = myOrders.where((order) => order['status'] != 'Delivered').toList();


        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  
  
  Future<void> _paymentByWallet(int walletPrice, String orderId, String paymentId,) async{
    final url  = Uri.parse('https://fabspin.org/api/pay-from-wallet');
    final response = await http.post(url, body: jsonEncode({
      'customer_id': userId.toString(),
      'amount': walletPrice,
      "booking_id": bookingid.toString(),
    },),
    headers: {'Content-Type': 'application/json'},
    );
    final responseData = jsonDecode(response.body);

    if(responseData['success'] == true){
      print('Payment Success through Wallet $responseData');
      //savePaymentDetails(orderId.toString(), paymentId, walletPrice);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> BookingConfirmation(bookingId: bookingcode.toString(), event: "Payment Successful", eventDesc: "Order Id:")));

    }else{
      Navigator.pop(context);
      showSnackBarView(
          context,
          responseData['message'],
          Colors.red);


      print("Payment Failed $responseData");
    }
  }
  

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    initializeRazorpay();
    _loadUserData();
    _myOrders();
    getAmount();
  }




  @override
  Widget build(BuildContext context) {
    List filteredOrdersToShow = [];
    if (selectedFilter == 'Orders') {
      filteredOrdersToShow = filteredOrders; // Show all non-delivered orders
    } else if (selectedFilter == 'Processing') {
      filteredOrdersToShow = myOrders.where((order) => order['status'] == 'Processing').toList();
    } else if (selectedFilter == 'Ready ') {
      filteredOrdersToShow = myOrders.where((order) => order['status'] == 'Ready ').toList();
    }
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
        //   ),
        // ),
        child: Column(
          children: [
            TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                dividerColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.black,
                      Colors.grey,
                      Colors.black,
                    ]),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent),
                controller: tabController,
                tabs: [
                  Tab(
                    text: 'PENDING',
                  ),
                  Tab(
                    text: 'COMPLETED',
                  )
                ]),
            //SizedBox(height: 10,),
            Expanded(
              child: TabBarView(controller: tabController, children: [
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Orders'; // Show all orders
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: selectedFilter == 'Orders' ? Colors.grey : Colors.white, // Highlight
                                ),
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(Ionicons.cart_outline),
                                      SizedBox(width: 10),
                                      Text('Orders', style: GoogleFonts.sourceSans3(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold,
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Processing'; // Show processing orders
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: selectedFilter == 'Processing' ? Colors.grey : Colors.white, // Highlight
                                ),
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(Ionicons.accessibility_outline),
                                      SizedBox(width: 10),
                                      Text('Processing', style: GoogleFonts.sourceSans3(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold,
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.black,
                    ),
                    Container(
                      color: Colors.black,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Icon(Ionicons.wallet_outline),
                                    SizedBox(width: 10),
                                    Text('Due Rs. ${totalamount}', style: GoogleFonts.sourceSans3(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                    ),),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedFilter = 'Ready '; // Show ready orders
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: selectedFilter == 'Ready ' ? Colors.grey : Colors.white, // Highlight
                                ),
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.local_shipping_outlined),
                                      SizedBox(width: 10),
                                      Text('Ready', style: GoogleFonts.sourceSans3(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold,
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    filteredOrdersToShow.isNotEmpty
                        ? Expanded(
                      child: ListView.builder(
                        itemCount: filteredOrdersToShow.length,
                        itemBuilder: (BuildContext context, index) {
                          final order = filteredOrdersToShow[index];

                          // Image handling based on service name
                          String imgUrl;
                          if (order['service_name'] == 'Dryclean') {
                            imgUrl = dryCleanImg;
                          } else if (order['service_name'] == 'Shoes/Bag Cleaning') {
                            imgUrl = shoeCleanImg;
                          } else if (order['service_name'] == 'Steam Press') {
                            imgUrl = steamIronImg;
                          } else {
                            imgUrl =
                            'https://media.istockphoto.com/id/1055079680/vector/black-linear-photo-camera-like-no-image-available.jpg?s=612x612&w=0&k=20&c=P1DebpeMIAtXj_ZbVsKVvg-duuL0v9DlrOZUvPG6UJk='; // Default case if service doesn't match
                          }

                          return Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailsScreen(id: order["id"]),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          //SizedBox(width: 5,),
                                          // Padding(
                                          //   padding: const EdgeInsets.all(15),
                                          //   child: Image.network(
                                          //     imgUrl,
                                          //     width: 70,
                                          //     height: 70,
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${order['service_name']}',
                                                  style: GoogleFonts.sourceSans3(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey,
                                                    letterSpacing: 1,
                                                    fontSize: 15,
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                Text("Amount : Rs. ${order['order_total_amount_due'].toString()}", style: GoogleFonts.sourceSans3(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  letterSpacing: 1,
                                                  fontSize: 12,
                                                  //fontWeight: FontWeight.bold,
                                                ),),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text("${order['booking_code'].toString()}", style: GoogleFonts.sourceSans3(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                letterSpacing: 1,
                                                fontSize: 12,
                                                //fontWeight: FontWeight.bold,
                                              ),),
                                              SizedBox(height: 5),
                                              Text("Quantity : ${order['quantity']}", style: GoogleFonts.sourceSans3(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                letterSpacing: 1,
                                                fontSize: 12,
                                                //fontWeight: FontWeight.bold,
                                              ),),
                                              // SizedBox(height: 5),
                                              // Text("Order Date : ${order['created_at']}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                                              // SizedBox(height: 5),
                                            ],
                                          ),
                                          //SizedBox(width: 5,)
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          child: Container(
                                            //margin: EdgeInsets.only(top: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              border: Border.all(color: Colors.black),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            height: 35,
                                            width: 80,
                                            child: Center(
                                              child: Text(
                                                'Track',
                                                style: GoogleFonts.sourceSans3(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  letterSpacing: 1,
                                                  fontSize: 12,
                                                  //fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => OrderTrackingPage(),
                                              ),
                                            );
                                          },
                                        ),
                                        //SizedBox(width: 2),
                                        if (order['order_total_amount_due'] != 0)
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.pop(context);
                                                              print("Wallet tapped");
                                                              showDialog(context: context, builder: (BuildContext context){
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Padding(padding: EdgeInsets.all(16),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text('Order Number: ${order['booking_code']}'),
                                                                      SizedBox(height: 5,),
                                                                       Text('Wallet Balance: ${walletAmount}'),
                                                                      SizedBox(height: 5,),
                                                                       Text('Bill Amount: ${order['order_total_amount_due']}.00'),


                                                                      SizedBox(height: 20,),
                                                                     Row(
                                                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                       children: [
                                                                         InkWell(
                                                                           onTap: (){
                                                                              _paymentByWallet(order['order_total_amount_due'], order['id'].toString(), '' );
                                                                           },
                                                                           child: Container(
                                                                             padding: EdgeInsets.only(left: 30, right: 30, top: 16, bottom: 16),
                                                                             decoration: BoxDecoration(
                                                                               border: Border.all(color: Colors.black),
                                                                               color: Colors.black,
                                                                               borderRadius: BorderRadius.circular(10),
                                                                             ),
                                                                             child: Center(
                                                                               child: Text('Pay', style: TextStyle(fontSize: 18, color: Colors.white)),
                                                                             ),
                                                                           ),
                                                                         ),
                                                                         InkWell(
                                                                           onTap: (){
                                                                             Navigator.pop(context);                                                                           },
                                                                           child: Container(
                                                                             padding: EdgeInsets.all(16),
                                                                             decoration: BoxDecoration(
                                                                               border: Border.all(color: Colors.black),
                                                                               color: Colors.grey,
                                                                               borderRadius: BorderRadius.circular(10),
                                                                             ),
                                                                             child: Center(
                                                                               child: Text('Cancel', style: TextStyle(fontSize: 18)),
                                                                             ),
                                                                           ),
                                                                         ),
                                                                       ],
                                                                     )
                                                                    ],
                                                                  ),
                                                                  ),
                                                                );
                                                              });
                                                              //_paymentByWallet(order['order_total_amount_due'], order['id'].toString(), '' );
                                                              setState(() {
                                                                bookingid = order['id'];
                                                                bookingcode = order['booking_code'];
                                                              });
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(16),
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: Colors.black),
                                                                color: Colors.grey,
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Center(
                                                                child: Text('Wallet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 16),
                                                          InkWell(
                                                            onTap: () {
                                                              createRazorpayOrder(
                                                                order['order_total_amount_due'],
                                                                order['service_name'],
                                                                '',
                                                                order['booking_code'],
                                                              );
                                                              setState(() {
                                                                price = order['order_total_amount_due'];
                                                                bookingid = order['id'];
                                                              });
                                                              Navigator.pop(context);
                                                              print("Razorpay tapped");
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(16),
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: Colors.black),
                                                                color: Colors.grey,
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Center(
                                                                child: Text('Razorpay', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              //margin: EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                border: Border.all(color: Colors.white),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Pay',
                                                  style: GoogleFonts.sourceSans3(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    letterSpacing: 1,
                                                    fontSize: 12,
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              height: 35,
                                              width: 80,
                                            ),
                                          ),
                                        Container(
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                                          child: Center(child: Text('View', style: GoogleFonts.sourceSans3(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            letterSpacing: 1,
                                            fontSize: 12,
                                            //fontWeight: FontWeight.bold,
                                          ),)),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : Center(child: Text("No Orders")),

                    SizedBox(
                      height: 20,
                    )
                  ],
                ),




                deliveredOrders.isNotEmpty
                    ? ListView.builder(
                      itemCount: deliveredOrders.length,
                      itemBuilder: (BuildContext context, index) {
                        final order = deliveredOrders[index];
                        print(deliveredOrders.length);

                        String imgUrl;
                        if (order['service_name'] == 'Dryclean') {
                          imgUrl = dryCleanImg;
                        } else if (order['service_name'] == 'Shoes/Bag Cleaning') {
                          imgUrl = shoeCleanImg;
                        } else if (order['service_name'] == 'Steam Press') {
                          imgUrl = steamIronImg;
                        } else {
                          imgUrl =
                          'https://media.istockphoto.com/id/1055079680/vector/black-linear-photo-camera-like-no-image-available.jpg?s=612x612&w=0&k=20&c=P1DebpeMIAtXj_ZbVsKVvg-duuL0v9DlrOZUvPG6UJk='; // Default case if service doesn't match
                        }

                        return Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsScreen(id: order['id']),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                border: Border.all(color: Colors.black),
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
                                              '${order['service_name']}',
                                              style: GoogleFonts.sourceSans3(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey,
                                                letterSpacing: 1,
                                                fontSize: 15,
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${order['booking_code']}", style: GoogleFonts.sourceSans3(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              letterSpacing: 1,
                                              fontSize: 12,
                                              //fontWeight: FontWeight.bold,
                                            ),),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Quantity : ${order['quantity'].toString()}", style: GoogleFonts.sourceSans3(
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
                                                child: Text('View', style: GoogleFonts.sourceSans3(
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
                        );
                      },
                    )
                    : Center(child: Text("No Delivered Orders"))
              ]),
            )
          ],
        ),
      ),
    );
  }



  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? 'Email';
      _mobiie = prefs.getString('mobile') ?? 'Mobile';
    });
  }

  @override
  void handlePaymentFailureEvent(PaymentFailureResponse failureResponse) {
    // TODO: implement handlePaymentFailureEvent
    print('PaymentFailureResponse ${failureResponse.error}');
    print('PaymentFailureResponse ${failureResponse.code}');
    print('PaymentFailureResponse ${failureResponse.message}');

    /// here just show the payment failure message with the help of snackbar.
    //showSnackBarView(context, failureResponse.message.toString(), Colors.red);
    showSnackBarView(context, "Payment Failed", Colors.red);
  }

  @override
  void handlePaymentSuccessEvent(PaymentSuccessResponse successResponse) {
    // TODO: implement handlePaymentSuccessEvent
    print('successResponse paymentID ${successResponse.paymentId}');
    print('successResponse orderID ${successResponse.orderId}');
    print('successResponse signature ${successResponse.signature}');

    savePaymentDetails(successResponse.orderId.toString(),
        successResponse.paymentId.toString(), price);

    /// here is i just show snackBar with provided success response message, you can add here verify signature code.
    // showSnackBarView(
    //     context,
    //     successResponse.orderId.toString() == null ||
    //             successResponse.orderId.toString() == ""
    //         ? "Payment Successfully Done"
    //         : successResponse.orderId.toString(),
    //     Colors.green);

    showSnackBarView(
        context,
        "Payment Successfully Done",
        Colors.green);
  }

  @override
  void handleWalletResponse(ExternalWalletResponse externalWalletResponse) {
    // TODO: implement handleWalletResponse
  }

  @override
  initializeRazorpay() {
    // TODO: implement initializeRazorpay
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessEvent);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailureEvent);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleWalletResponse);
  }

  @override
  void openRazorPaySession(int price, String productName,
      String productDescription, String orderId) {
    // TODO: implement openRazorPaySession
    print('openRazorPaySession Order ID: $orderId');
    print('price $price');
    print('productName $productName');
    print('productDescription $productDescription');
    print('orderId $orderId');
    try {
      var options = {
        'key': _razorpayKey,
        'amount': price * 100,
        'name': productName,
        'description': productDescription,
        'order_id': orderId,
        'prefill': {'contact': _mobiie, 'email': _email}
      };
      _razorpay.open(options);
    } catch (error) {
      print("error ==>$error");
    }
  }

  @override
  void dispose() {
    /// using razorpay we clear all event handlers...

    _razorpay.clear();
    super.dispose();
  }

  void createRazorpayOrder(
      int price, String serviceName, String desc, String orderId) async {
    // Razorpay API credentials
    String keyId = _razorpayKey; // Replace with your Razorpay key_id
    String keySecret =
        '2mrkDNFBcKI3RgdjjnEqo24r'; // Replace with your Razorpay key_secret

    // Body for the request
    Map<String, dynamic> body = {
      "amount": price * 100, // Amount in paise (5000 INR)
      "currency": "INR",
      "receipt": "receipt#1",
      "payment_capture": 1 // Automatically capture the payment
    };

    var response = await http.post(
      Uri.https("api.razorpay.com", "/v1/orders"), // Using https
      body: jsonEncode(body), // Convert body to JSON
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$keyId:$keySecret'))}' // Basic Auth header
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Response Data: $responseData");

      // Extract the order_id from the response
      String orderId = responseData['id'];

      setState(() {
        checkConnectivity().then((value) {
          if (value == false) {
            showSnackBarView(
                context, "Please Check Network Connectivity", Colors.red);
          } else {
            print('Order ID being passed to Razorpay: $orderId');
            // Pass the dynamically generated orderId from Razorpay
            openRazorPaySession(
              price, // Amount in INR
              serviceName,
              desc,
              orderId, // Use the actual order ID
            );
          }
        });
      });
    } else {
      print("Error: Status Code ${response.statusCode}");
      showSnackBarView(context, "Something went wrong", Colors.red);
    }
  }

  Future<void> savePaymentDetails(
      String orderId, String paymentId, int price) async {
    final body = {
      "transaction_id": paymentId,
      "amount": price,
      "payment_method": "card",
      "status": "1",
      "razorpay_order_id": orderId,
      "receipt": "rec_456789",
      "notes": "Services",
      "booking_id": bookingid.toString(),
      "customer_id": userId
    };
    final url = Uri.parse('https://fabspin.org/api/transaction-store');

    try {
      final response = await http.post(
        url,
        body: json.encode(body), // Convert body to JSON
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Payment Details Saved: ${jsonDecode(response.body)}");

        //Navigator.push(context, MaterialPageRoute(builder: (context)=> BookingConfirmation(bookingId: bookingcode.toString(), event: "Payment Successful", eventDesc: "Order Id:")));


      } else {
        print("Payment Details Not Saved: Status Code ${response.statusCode}");
        print("Response Body: ${response.body}"); // Log the response body
      }
    } catch (e) {
      print("Error saving payment details: $e");
    }
  }
}



