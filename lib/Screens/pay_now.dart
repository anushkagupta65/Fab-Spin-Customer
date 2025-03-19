import 'dart:convert';

import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/app_components.dart';
import '../paymentservice/paymentservice.dart';
import '../tabs/custom_drawer.dart';
import 'booking_confirmation.dart';
import 'notificaton_screen.dart';

class PayNow extends StatefulWidget {
  const PayNow({super.key});

  @override
  State<PayNow> createState() => _PayNowState();
}

class _PayNowState extends State<PayNow> implements PaymentService{
  bool isPaymentCompleted = false;

  int totalamount = 0; // Initialize totalamount with 0
  final Razorpay _razorpay = Razorpay();
  final _razorpayKey = "rzp_live_f6t7NV0566alc2";
  String _email = '';
  String _mobiie = '';

  Future<void> getAmount() async {
    final url = Uri.parse('https://fabspin.org/api/pending-amount/${userId}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        totalamount = responseData['pending_amount'];
      });

      print("Wallet Amount ${totalamount.toString()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
    initializeRazorpay();
    getAmount();
  }


  Future<void> _paymentByWallet()async{
    final url  = Uri.parse('https://fabspin.org/api/pay-from-wallet');
    final response = await http.post(url, body: jsonEncode({
      'customer_id': userId.toString(),
      'amount': totalamount,
    },),
      headers: {'Content-Type': 'application/json'},
    );
    final responseData = jsonDecode(response.body);

    if(responseData['success'] == true){
      print('Payment Success through Wallet $responseData');
      //savePaymentDetails("orderId.toString()", 'paymentId', totalamount);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> BookingConfirmation(bookingId: totalamount.toString(), event: "Payment Successful", eventDesc: "Rs ")));

    }else{
      print("Payment Failed $responseData");
      Navigator.pop(context);
      showSnackBarView(
          context,
          responseData['message'],
          Colors.red);
    }
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
      body: isPaymentCompleted
      ? Center(child: CircularProgressIndicator(color: Colors.black,),)
      :Container(
        color: Colors.white,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount Due:',
                      style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: 15,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('\u{20B9}${totalamount}',
                        style:
                        GoogleFonts.sourceSans3(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontSize: 15,
                          //fontWeight: FontWeight.bold,
                        ),),
                  ],
                ),

                SizedBox(height: 200,),

                if(totalamount != 0)
                InkWell(
                  onTap: (){
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
                                    // Handle Wallet tap
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
                                              //Text('Order Number: ${order['booking_code']}'),
                                              SizedBox(height: 5,),
                                              Text('Wallet Balance: ${walletAmount}',  style: TextStyle(fontSize: 12),),
                                              SizedBox(height: 5,),
                                              Text('Bill Amount: ${totalamount}.00', style: TextStyle(fontSize: 12),),


                                              SizedBox(height: 20,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      _paymentByWallet();
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 30, right: 30, top: 16, bottom: 16),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.black),
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Center(
                                                        child: Text('Pay', style: TextStyle(fontSize: 15, color: Colors.white)),
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
                                                        child: Text('Cancel', style: TextStyle(fontSize: 15)),
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
                                   // _paymentByWallet();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(child: Text('Wallet', style: TextStyle(fontSize: 18))),
                                  ),
                                ),
                                SizedBox(height: 16),
                                InkWell(
                                  onTap: () {
                                    // Handle Razorpay tap
                                    createRazorpayOrder();
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
                                    child: Center(child: Text('Razorpay', style: TextStyle(fontSize: 18))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    //createRazorpayOrder();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                      child: Text("Pay Now", style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 15,
                        //fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                )
                
              ],
            )
          ),
        ),
      ),
    );
  }




  @override
  void handlePaymentFailureEvent(PaymentFailureResponse failureResponse) {
    // TODO: implement handlePaymentFailureEvent
    print('PaymentFailureResponse ${failureResponse.error}');
    print('PaymentFailureResponse ${failureResponse.code}');
    print('PaymentFailureResponse ${failureResponse.message}');

    /// here just show the payment failure message with the help of snackbar.
    showSnackBarView(
        context, failureResponse.message.toString(), Colors.red);
  }

  @override
  void handlePaymentSuccessEvent(PaymentSuccessResponse successResponse) {
    // TODO: implement handlePaymentSuccessEvent
    print('successResponse paymentID ${successResponse.paymentId}');
    print('successResponse orderID ${successResponse.orderId}');
    print('successResponse signature ${successResponse.signature}');

    savePaymentDetails(successResponse.orderId.toString(), successResponse.paymentId.toString(), totalamount);

    /// here is i just show snackBar with provided success response message, you can add here verify signature code.
    showSnackBarView(
        context,
        successResponse.orderId.toString() == null ||
            successResponse.orderId.toString() == ""
            ? "Payment Successfully Done"
            : successResponse.orderId.toString(),
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
    print(price);
    print('productName $productName');
    print('productDescription $productDescription');
    print('orderId $orderId');

    try {
      var options = {
        'key': _razorpayKey,
        'amount':  price ,
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

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? 'Email';
      _mobiie = prefs.getString('mobile') ?? 'Mobile';

    });
  }



  @override
  void dispose() {
    /// using razorpay we clear all event handlers...

    _razorpay.clear();
    super.dispose();
  }


  void createRazorpayOrder() async {
    print("First Call${totalamount}");
    // Razorpay API credentials
    String keyId = _razorpayKey; // Replace with your Razorpay key_id
    String keySecret = '2mrkDNFBcKI3RgdjjnEqo24r'; // Replace with your Razorpay key_secret

    // Body for the request
    Map<String, dynamic> body = {
      "amount":  totalamount * 100, // Amount in paise (5000 INR)
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
      print(totalamount);

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
              totalamount , // Amount in INR
              "Pay Now",
              "Pay Remaining Amount" ?? "Description",
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
      "amount": price,
      "payment_method": "card",
      "status": "1",
      "razorpay_order_id": orderId,
      "receipt": "rec_456789",
      "notes": "Pay Now",
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


        final url = Uri.parse('https://fabspin.org/api/order-amount-paid/${userId}');
        final responce = await http.post(url, headers: {'Content-Type': 'application/json'},);
        if(responce.statusCode ==200){
          setState(() {
            //isPaymentCompleted = true;
            // Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => PayNow(), // Replace with your actual page widget
            //   ),
            // );
            //Navigator.push(context, MaterialPageRoute(builder: (context)=> BookingConfirmation(bookingId: totalamount.toString(), event: "Payment Successful", eventDesc: "Rs ")));

          });
          print(" Payment of Paynow page is successfull: ${responce}");
        }
        else{

          print(" Payment of Paynow page is Failedddd");
        }

      } else {
        print("Payment Details Not Saved: Status Code ${response.statusCode}");
        print("Response Body: ${response.body}"); // Log the response body
      }
    } catch (e) {
      print("Error saving payment details: $e");
    }
  }



}
