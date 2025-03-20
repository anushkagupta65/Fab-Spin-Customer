import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../components/app_components.dart';
import '../paymentservice/paymentservice.dart';
import '../tabs/custom_drawer.dart';
import 'notificaton_screen.dart';

class Promotions extends StatefulWidget {
  const Promotions({super.key});

  @override
  State<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions>
    with SingleTickerProviderStateMixin
    implements PaymentService {
  TabController? tabController;
  List<dynamic> getpromotions = [];
  List<bool> isAppliedList = [];
  List<bool> isAppliedList2 = [];
  final Razorpay _razorpay = Razorpay();
  final _razorpayKey = "rzp_live_f6t7NV0566alc2";
  final price = 0;
  String _email = '';
  String _mobile = '';
  var promotionid;
  var promotionamount;
  var title;
  var description;

  int get amount => (double.parse(promotionamount) * 100).round();

  Future<void> updateWallet() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt('user_id');
    final url = Uri.parse('https://fabspin.org/api/wallet');
    final response = await http.post(url, body: {
      "customer_id": userId.toString(),
      "promotionandoffer_id": promotionid.toString(),
    });
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print(responseData);
    }
  }

  TextEditingController balanceController = TextEditingController();
  int _selectedIndex = 0;

  Future<void> getPromotions() async {
    final url = Uri.parse('https://fabspin.org/api/promotion-and-offers');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        getpromotions = responseData['data'];
        isAppliedList = List.generate(getpromotions.length, (_) => false);
        isAppliedList2 = List.generate(getpromotions.length, (_) => false);
      });
      print(getpromotions);
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    getPromotions().then((_) {
      if (getpromotions.isNotEmpty) {
        setState(() {
          isAppliedList[0] = true;
          promotionid = getpromotions[0]['id'];
          promotionamount = getpromotions[0]['amount'];
          title = getpromotions[0]['title'];
          description = getpromotions[0]['description'];
          balanceController.text = promotionamount;
        });
      }
    });
    initializeRazorpay();
    _loadUserData();
    super.initState();
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
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          Badge(
            backgroundColor: Colors.grey,
            label: Text(walletAmount.substring(0, walletAmount.length - 3),
                style: TextStyle(color: Colors.white)),
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
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Buy Promotions",
                          style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 15,
                          ),
                        ),
                        TextField(controller: balanceController),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: getpromotions.length,
                            itemBuilder: (context, index) {
                              final recharge = getpromotions[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    isAppliedList2[index]
                                        ? balanceController.text = ''
                                        : balanceController.text =
                                            recharge['amount'].toString();
                                    isAppliedList2[index] =
                                        !isAppliedList2[index];
                                    promotionid = recharge['id'];
                                    promotionamount = recharge['amount'];
                                    title = recharge['title'];
                                    description = recharge['description'];
                                    balanceController.text =
                                        isAppliedList2[index]
                                            ? recharge['amount']
                                            : '';
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Center(
                                      child:
                                          Text(recharge['amount'].toString()),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Recommended Offers',
                          style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: getpromotions.length,
                            itemBuilder: (context, index) {
                              final promo = getpromotions[index];
                              return _promotionCard(
                                name: promo['title'] ?? 'Not Found',
                                price: promo['amount'],
                                discount: promo['description'] ?? 'Not Found',
                                isApplied: isAppliedList[index],
                                voidCallback: () {
                                  setState(() {
                                    for (int i = 0;
                                        i < isAppliedList.length;
                                        i++) {
                                      if (i != index) {
                                        isAppliedList[i] = false;
                                      }
                                    }
                                    promotionid = promo['id'];
                                    promotionamount = promo['amount'];
                                    title = promo['title'];
                                    description = promo['description'];
                                    isAppliedList[index] =
                                        !isAppliedList[index];
                                    balanceController.text =
                                        isAppliedList[index]
                                            ? promo['amount']
                                            : '';
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: createRazorpayOrder,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "PAY ${balanceController.text}",
                      style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? 'Email';
      _mobile = prefs.getString('mobile') ?? 'Mobile';
    });
  }

  @override
  void handlePaymentFailureEvent(PaymentFailureResponse failureResponse) {
    print('PaymentFailureResponse ${failureResponse.error}');
    showSnackBarView(context, "Payment Failed", Colors.red);
  }

  @override
  void handlePaymentSuccessEvent(PaymentSuccessResponse successResponse) {
    savePaymentDetails(successResponse.orderId.toString(),
        successResponse.paymentId.toString(), amount);
    updateWallet();
    showSnackBarView(context, "Payment Successfully Done", Colors.green);
  }

  @override
  void handleWalletResponse(ExternalWalletResponse externalWalletResponse) {}

  @override
  initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessEvent);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailureEvent);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleWalletResponse);
  }

  @override
  void openRazorPaySession(int price, String productName,
      String productDescription, String orderId) {
    try {
      var options = {
        'key': _razorpayKey,
        'amount': amount,
        'name': productName,
        'description': productDescription,
        'timeout': 60 * 5,
        'currency': 'INR',
        'order_id': orderId,
        'prefill': {
          'email': _email,
          'contact': _mobile,
        },
      };
      _razorpay.open(options);
    } catch (e) {
      print('Exception during Razorpay session: $e');
    }
  }

  void createRazorpayOrder() async {
    print("First Call${amount}");
    String keyId = _razorpayKey;
    String keySecret =
        '2mrkDNFBcKI3RgdjjnEqo24r'; // Replace with your Razorpay key_secret

    // Body for the request
    Map<String, dynamic> body = {
      "amount": amount, // Amount in paise (5000 INR)
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
      print(amount);

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
              amount, // Amount in INR
              title.toString(),
              description.toString(),
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

  @override
  savePaymentDetails(String orderId, String paymentId, int amount) {}

  @override
  dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Widget _promotionCard({
    required String name,
    required String price,
    required String discount,
    required bool isApplied,
    required VoidCallback voidCallback,
  }) {
    var wallet = double.parse(walletAmount);
    return GestureDetector(
      onTap: voidCallback,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: isApplied ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isApplied ? Colors.black : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 12,
                  ),
                ),
                wallet > 150
                    ? SizedBox.shrink()
                    : Text(
                        "$discount",
                        style: GoogleFonts.sourceSans3(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          letterSpacing: 1,
                          fontSize: 15,
                        ),
                      ),
              ],
            ),
            Text("₹ $price"),
          ],
        ),
      ),
    );
  }
}
