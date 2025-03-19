import 'package:razorpay_flutter/razorpay_flutter.dart';

abstract class PaymentService {
  initializeRazorpay(){}


  void handlePaymentSuccessEvent(PaymentSuccessResponse successResponse){}



  void handlePaymentFailureEvent(PaymentFailureResponse failureResponse){}



  void handleWalletResponse(ExternalWalletResponse externalWalletResponse){
  }


  void openRazorPaySession(int price, String productName,
      String productDescription, String orderId) {}




}