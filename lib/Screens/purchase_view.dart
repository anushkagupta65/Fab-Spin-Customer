// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// import 'package:http/http.dart' as http;
//
// import '../components/app_components.dart';
// import '../paymentservice/paymentservice.dart';
//
// class PurchaseView extends StatefulWidget {
//
//   const PurchaseView({super.key});
//
//   @override
//   State<PurchaseView> createState() => _PurchaseViewState();
// }
//
// class _PurchaseViewState extends State<PurchaseView> implements PaymentService {
//   final Razorpay _razorpay = Razorpay();
//   final _razorpayKey = "rzp_test_t9nKkE2yOuYEkA";
//   // TextEditingController emailController = TextEditingController();
//   // TextEditingController passwordController = TextEditingController();
//   final List<String> sizeList = ["S", "M", "L", "XL"];
//   int qtyOfProduct = 1;
//   int selectedSizePos = 0;
//   int priceOfProduct = 130;
//   int finalPrice = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//           body: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.only(left: 10.0, top: 20.0),
//                   child: Text(
//                     'CheckOut',
//                     style: TextStyle(
//                         color: Colors.green,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 productDetailsView(
//                     "https://rukminim2.flixcart.com/image/832/832/xif0q/jacket/m/n/4/3xl-no-tblhdfulljacket-k29-tripr-original-imaggvw7ju84qdfe.jpeg?q=70",
//                     "Casual Jacket",
//                     "Casual Jacket For Winter with 16 different colours and also available cash on delivery with selected address.")
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Widget productDetailsView(
//       String urlOfProduct, String titleOfProduct, String desOfProduct) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 20.0),
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height * 0.3,
//             width: MediaQuery.of(context).size.width,
//             child: Image.network(urlOfProduct, fit: BoxFit.contain),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 20.0, left: 20.0),
//               child: Text(
//                 titleOfProduct,
//                 style: const TextStyle(
//                     color: Colors.green,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 20.0, right: 20.0),
//               child: Text(
//                 "R.S ${finalPrice.toString() == "0" ? priceOfProduct.toString() : finalPrice.toString()}",
//                 style: const TextStyle(
//                     color: Colors.green,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
//           child: Text(
//             desOfProduct,
//             style: const TextStyle(
//                 color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
//           ),
//         ),
//         const Padding(
//           padding: EdgeInsets.only(top: 25.0, left: 20.0),
//           child: Text(
//             "Size Of Product",
//             style: TextStyle(
//                 color: Colors.green, fontSize: 18, fontWeight: FontWeight.w500),
//           ),
//         ),
//         Padding(
//             padding: const EdgeInsets.only(top: 10.0, left: 20.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: getSizeWidget(context),
//               ),
//             )),
//         const Padding(
//           padding: EdgeInsets.only(top: 25.0, left: 20.0),
//           child: Text(
//             "Quantity Of Product",
//             style: TextStyle(
//                 color: Colors.green, fontSize: 18, fontWeight: FontWeight.w500),
//           ),
//         ),
//         Padding(
//             padding: const EdgeInsets.only(top: 25.0, left: 20.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     calculationOfProduct("minus");
//                   },
//                   child: CircleAvatar(
//                     radius: 22,
//                     backgroundColor: Colors.green.withOpacity(0.3),
//                     child: const Center(
//                       child: Icon(Icons.remove),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   qtyOfProduct.toString(),
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     calculationOfProduct("plus");
//                   },
//                   child: CircleAvatar(
//                     radius: 22,
//                     backgroundColor: Colors.green.withOpacity(0.3),
//                     child: const Center(
//                       child: Icon(Icons.add),
//                     ),
//                   ),
//                 ),
//               ],
//             )),
//         Padding(
//             padding: const EdgeInsets.only(top: 25.0, left: 20.0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   checkConnectivity().then((value) {
//                     if (value == false) {
//                       showSnackBarView(context,
//                           "Please Check Network Connectivity", Colors.red);
//                     } else {
//                       openRazorPaySession(
//                           finalPrice == 0 ? priceOfProduct : finalPrice,
//                           "Men Color black Casual Jacket",
//                           "Jacket For Man`s latest designed by awesome fabrics ",
//                           "#93974",
//                       );
//                     }
//                   });
//                 });
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 height: 52,
//                 decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(5),
//                     border: Border.all(
//                         color: Colors.grey.withOpacity(0.3), width: 1.0)),
//                 child: const Center(
//                   child: Text(
//                     "Buy Now",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             )),
//       ],
//     );
//   }
//
//   List<Widget> getSizeWidget(BuildContext context) {
//     List<Widget> sizeWidget = [];
//
//     for (int i = 0; i < (sizeList).length; i++) {
//       sizeWidget.add(GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedSizePos = i;
//           });
//         },
//         behavior: HitTestBehavior.opaque,
//         child: Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//                 color: selectedSizePos == i ? Colors.green : Colors.transparent,
//                 border: Border.all(color: Colors.grey, width: 1)),
//             child: Center(
//               child: Text(
//                 sizeList[i],
//                 textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: true,
//                 style: TextStyle(
//                     color: selectedSizePos == i ? Colors.white : Colors.black,
//                     fontSize: 14,
//                     fontWeight: selectedSizePos == i
//                         ? FontWeight.bold
//                         : FontWeight.w300),
//               ),
//             ),
//           ),
//         ),
//       ));
//     }
//
//     return sizeWidget;
//   }
//
//   void calculationOfProduct(String action) {
//     if (action == "plus") {
//       setState(() {
//         qtyOfProduct++;
//         finalPrice = priceOfProduct * qtyOfProduct;
//         print("final price of product$finalPrice");
//       });
//     } else if (action == "minus") {
//       setState(() {
//         if (qtyOfProduct > 1) {
//           qtyOfProduct--;
//           finalPrice = priceOfProduct * qtyOfProduct;
//           print("final price of product$finalPrice");
//         }
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     initializeRazorpay();
//     super.initState();
//   }
//
//   @override
//   initializeRazorpay() {
//     // TODO: implement initializeRazorpay
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessEvent);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailureEvent);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleWalletResponse);
//   }
//
//   @override
//   void handlePaymentFailureEvent(PaymentFailureResponse paymentFailureResponse) {
//     // TODO: implement handlePaymentFailureEvent
//
//     print('PaymentFailureResponse ${paymentFailureResponse.error}');
//     print('PaymentFailureResponse ${paymentFailureResponse.code}');
//     print('PaymentFailureResponse ${paymentFailureResponse.message}');
//
//     /// here just show the payment failure message with the help of snackbar.
//     showSnackBarView(
//         context, paymentFailureResponse.message.toString(), Colors.red);
//   }
//
//   @override
//   void handlePaymentSuccessEvent(PaymentSuccessResponse successResponse) {
//     // TODO: implement handlePaymentSuccessEvent
//     print('successResponse ${successResponse.paymentId}');
//     print('successResponse ${successResponse.orderId}');
//     print('successResponse ${successResponse.signature}');
//
//     /// here is i just show snackBar with provided success response message, you can add here verify signature code.
//     showSnackBarView(
//         context,
//         successResponse.orderId.toString() == null ||
//             successResponse.orderId.toString() == ""
//             ? "Payment Successfully Done"
//             : successResponse.orderId.toString(),
//         Colors.green);
//
//     /* verifySignature(successResponse.signature, successResponse.paymentId,
//         successResponse.orderId);*/
//   }
//
//   @override
//   void handleWalletResponse(ExternalWalletResponse externalWalletResponse) {
//     // TODO: implement handleWalletResponse
//
//     String chosenWallet =
//         externalWalletResponse.walletName ?? ""; // Capture chosen wallet name
//     switch (chosenWallet) {
//       case 'paytm':
//       // Display specific information for Paytm
//         break;
//       case 'freecharge':
//       // Display specific information for Freecharge
//         break;
//       default:
//       // Handle other wallets
//     }
//   }
//
//   @override
//   void openRazorPaySession(int price, String productName,
//       String productDescription, String orderId) {
//     // TODO: implement openRazorPaySession
//     print('price $price');
//     print('productName $productName');
//     print('productDescription $productDescription');
//     print('orderId $orderId');
//     try {
//       var options = {
//         'key': _razorpayKey,
//         'amount': price * 100,
//         'name': productName,
//         'description': productDescription,
//         'prefill': {'contact': '9794547665', 'email': 'hammadabu2002@gmail.com'}
//       };
//       _razorpay.open(options);
//     } catch (error) {
//       print("error ==>$error");
//     }
//   }
//
//   @override
//   void dispose() {
//     /// using razorpay we clear all event handlers...
//
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   void verifySignature(
//       String? signature, String? paymentId, String? orderId) async {
//     Map<String, dynamic> body = {
//       'razorpay_signature': signature,
//       'razorpay_payment_id': paymentId,
//       'razorpay_order_id': orderId,
//     };
//     var parts = [];
//
//     body.forEach((key, value) {
//       parts.add('${Uri.encodeQueryComponent(key)}='
//           '${Uri.encodeQueryComponent(value)}');
//     });
//     var formData = parts.join('&');
//     var res = await http.post(
//       Uri.https(
//         "10.0.2.2",
//         "razorpay_signature_verify.php",
//       ),
//       headers: {
//         "Content-Type": "application/x-www-form-urlencoded",
//       }, // urlencoded
//
//       body: formData,
//     );
//     if (res.statusCode == 200) {
//       /// here is you can navigate or show your message for user.
//     } else {
//       showSnackBarView(context, "Something went wrong", Colors.red);
//     }
//   }
// }