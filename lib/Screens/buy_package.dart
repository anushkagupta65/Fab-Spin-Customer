import 'dart:convert';
import 'dart:core';

import 'package:fabspin/Screens/wallet_history.dart';
import 'package:fabspin/paymentservice/paymentservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Urls/urls.dart';
import '../components/app_components.dart';
import '../tabs/custom_drawer.dart';
import 'notificaton_screen.dart';

class BuyPackage extends StatefulWidget {
  final Map<String, dynamic> promotion;
  BuyPackage({super.key,  required this.promotion});

  @override
  State<BuyPackage> createState() => _BuyPackageState();
}



class _BuyPackageState extends State<BuyPackage> implements PaymentService {
  final Razorpay _razorpay = Razorpay();
  final _razorpayKey = "rzp_test_t9nKkE2yOuYEkA";
  final price = 0;
  String _email = '';
  String _mobiie = '';
  //late final orderId;
  int get amount {
    // Convert to double first, then multiply by 100 and round to get the amount in paise
    return (double.parse(widget.promotion['amount']) * 100).round();
  }


  Future<void> updateWallet()async{
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt('user_id');
    final url = Uri.parse('https://fabspin.org/api/wallet');
    final response = await http.post(url, body: {
        "customer_id": userId.toString(),

        "promotionandoffer_id": widget.promotion['id'].toString(),
    },

    );
    if(response.statusCode == 201){
      final responseData = json.decode(response.body);

       print(responseData);
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white ,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Fabspin', style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
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
      ),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.09,
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(widget.promotion['image'] ?? 'https://img.freepik.com/free-vector/big-sales-label-design_1232-4616.jpg'),
                  SizedBox(height: 20,),
                  //Text('Super Saver Package - 5000(15%)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Text(widget.promotion['title'] , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(height: 20,),
                  Text(widget.promotion['description'] ?? "Description: " ),
                  SizedBox(height: 10,),
                  Text('Price: Rs. ${widget.promotion['amount']}', ),
                  SizedBox(height: 10,),
                  Text('Validity: Unlimited ', ),
                  Divider(),
                ],),
            ),


            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(
                              context
                          );
                        },
                        child: Container(
                          child: Center(child: Text('Back', style: TextStyle(color: Colors.white),)),
                          height: 60,

                          color: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: (){
                          // setState(() {
                          //   checkConnectivity().then((value) {
                          //     if (value == false) {
                          //       showSnackBarView(context,
                          //           "Please Check Network Connectivity", Colors.red);
                          //     } else {
                          //       openRazorPaySession(
                          //         10,
                          //         "Super Saver Package",
                          //         "Price 5000 For all Services ",
                          //         "#92135",
                          //       );
                          //     }
                          //   });
                          // });
                          createRazorpayOrder();
                        },
                        child: Container(
                          child: Center(child: Text('Buy Now', style: TextStyle(color: Colors.white))),
                          height: 60,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
    // showSnackBarView(
    //     context, failureResponse.message.toString(), Colors.red);
    showSnackBarView(context, "Payment Failed", Colors.red);
  }

  @override
  void handlePaymentSuccessEvent(PaymentSuccessResponse successResponse) {
    // TODO: implement handlePaymentSuccessEvent
    print('successResponse paymentID ${successResponse.paymentId}');
    print('successResponse orderID ${successResponse.orderId}');
    print('successResponse signature ${successResponse.signature}');

    savePaymentDetails(successResponse.orderId.toString(), successResponse.paymentId.toString(), amount);

    /// here is i just show snackBar with provided success response message, you can add here verify signature code.
    // showSnackBarView(
    //     context,
    //     successResponse.orderId.toString() == null ||
    //         successResponse.orderId.toString() == ""
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
  void openRazorPaySession(int price, String productName, String productDescription, String orderId) {
    // TODO: implement openRazorPaySession
    print('openRazorPaySession Order ID: $orderId');
    print(amount);
    print('productName $productName');
    print('productDescription $productDescription');
    print('orderId $orderId');
    print("Promo ID ${widget.promotion['id']}");
    try {
      var options = {
        'key': _razorpayKey,
        'amount':  amount ,
        'name': productName,
        'description': productDescription ?? "Description",
        'order_id' : orderId,
        'prefill': {'contact': _mobiie, 'email': _email}
      };
      _razorpay.open(options);
    } catch (error) {
      print("error ==>$error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeRazorpay();
    _loadUserData();
    super.initState();
  }

  @override
  void dispose() {
    /// using razorpay we clear all event handlers...

    _razorpay.clear();
    super.dispose();
  }


  void createRazorpayOrder() async {
    print("First Call${amount}");
    // Razorpay API credentials
    String keyId = _razorpayKey; // Replace with your Razorpay key_id
    String keySecret = 'fLf4GyMehyvF4gY1IyaN0NxE'; // Replace with your Razorpay key_secret

    // Body for the request
    Map<String, dynamic> body = {
      "amount":  amount, // Amount in paise (5000 INR)
      "currency": "INR",
      "receipt": "receipt#1",
      "payment_capture": 1 // Automatically capture the payment
    };

    var response = await http.post(
      Uri.https("api.razorpay.com", "/v1/orders"), // Using https
      body: jsonEncode(body), // Convert body to JSON
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$keyId:$keySecret'))}' // Basic Auth header
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
            showSnackBarView(context, "Please Check Network Connectivity", Colors.red);
          } else {
            print('Order ID being passed to Razorpay: $orderId');
            // Pass the dynamically generated orderId from Razorpay
            openRazorPaySession(
              amount , // Amount in INR
              widget.promotion['title'].toString(),
              widget.promotion['description'].toString() ?? "Description",
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






  Future<void> savePaymentDetails(String orderId, String paymentId, int price) async {
    final body = {
      "transaction_id": paymentId,
      "amount": amount,
      "payment_method": "card",
      "status": "1",
      "razorpay_order_id": orderId,
      "receipt": "rec_456789",
      "notes": "Services",
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
        updateWallet();
      } else {
        print("Payment Details Not Saved: Status Code ${response.statusCode}");
        print("Response Body: ${response.body}"); // Log the response body
      }
    } catch (e) {
      print("Error saving payment details: $e");
    }
  }





}
