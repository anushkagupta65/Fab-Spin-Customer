import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../Urls/urls.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int id;
  const OrderDetailsScreen({super.key, required this.id});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

List<dynamic> bookingDetails = [];

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Future<void> _orderDetails() async {
    final url = Uri.parse(Urls.orderDetails);
    try {
      final response = await http.post(
        url,
        body: json.encode({'booking_id': widget.id}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("responseData: $responseData");
        setState(() {
          bookingDetails = responseData['booking_details'];
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.cyan;
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.black;
      default:
        return Colors.blue; // For any other statuses
    }
  }


  @override
  void initState() {
    super.initState();
    _orderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Order Details', style: GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 1,
          fontSize: 20,
          //fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bookingDetails.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Text(
                    'Booking Code : ${bookingDetails[0]['booking_code']}',
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      letterSpacing: 1,
                      fontSize: 12,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(), // Disable scroll on ListView.builder
                  shrinkWrap: true, // Make ListView fit the content
                  itemCount: bookingDetails.length,
                  itemBuilder: (context, index) {
                    final bookingDetail = bookingDetails[index];
                    return Container(
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${index + 1}.'),
                            SizedBox(width: 2,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Name : ${bookingDetail['service_name']}',
                                  style: GoogleFonts.sourceSans3(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Category : ${bookingDetail['subtrade_name']}',
                                  style: GoogleFonts.sourceSans3(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12
                                  ),
                                ),
                                Text(
                                  'Item Name: ${bookingDetail['cloth_name']}',
                                  style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w400,
                                      fontSize: 12
                                  ),
                                ),
                                Text(
                                  'Status: ${bookingDetail['status']}',
                                  style: GoogleFonts.sourceSans3(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    color: _getStatusColor(bookingDetail['status']),
                                  ),
                                ),
                                //Divider(color: Colors.black,)
                              ],
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 10),
                  child: Text(
                    'Shipping Details',
                    style: GoogleFonts.sourceSans3(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bookingDetails[0]['full_address'] ?? 'No Address Found',style: GoogleFonts.sourceSans3(fontWeight: FontWeight.w400,
                            fontSize: 12),),
                        Text(bookingDetails[0]['mobile'], style: GoogleFonts.sourceSans3(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontSize: 12,
                          //fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 10),
                  child: Text(
                    'Price Details',
                    style: GoogleFonts.sourceSans3(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Discount: ', style: GoogleFonts.sourceSans3(fontWeight: FontWeight.bold, fontSize: 12),),
                              Text('SGst: ',style: GoogleFonts.sourceSans3(fontWeight: FontWeight.bold, fontSize: 12),),
                              Text('CGst: ',style: GoogleFonts.sourceSans3(fontWeight: FontWeight.bold, fontSize: 12),),
                              Text('Amount Paid: ',style: GoogleFonts.sourceSans3(fontWeight: FontWeight.bold, fontSize: 12),),
                              Text('Amount Due: ',style: GoogleFonts.sourceSans3(fontWeight: FontWeight.bold, fontSize: 12),),
                              SizedBox(height: 5),
                              Divider(
                                color: Colors.grey, // Set the color of the line
                                thickness: 1, // Set the thickness of the line
                                height: 20,
                              ),
                              SizedBox(height: 5),
                              Text('Total: ',style: GoogleFonts.sourceSans3(fontWeight: FontWeight.bold),),

                            ],
                          ),
                        ),Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Rs. ${bookingDetails[0]['discount'].toString()}", style: GoogleFonts.sourceSans3(fontSize: 12, fontWeight: FontWeight.w400),
                              ),Text(
                                "Rs. ${bookingDetails[0]['sgst'].toString()}",style: GoogleFonts.sourceSans3(fontSize: 12, fontWeight: FontWeight.w400),
                              ),Text(
                                "Rs. ${bookingDetails[0]['cgst'].toString()}",style: GoogleFonts.sourceSans3(fontSize: 12, fontWeight: FontWeight.w400),
                              ),Text(
                                "Rs. ${bookingDetails[0]['order_amount_paid'].toString()}" ?? '0',style: GoogleFonts.sourceSans3(fontSize: 12, fontWeight: FontWeight.w400),
                              ),Text(
                                "Rs. ${bookingDetails[0]['order_total_amount_due'].toString()}" ?? '0',style: GoogleFonts.sourceSans3(fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 5),
                              Divider(
                                color: Colors.grey, // Set the color of the line
                                thickness: 1, // Set the thickness of the line
                                height: 20,                          ),
                              SizedBox(height: 5),
                              Text(
                                "Rs. ${bookingDetails[0]['order_total_after_tax'].toString()}",
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Center(
                  child: CircularProgressIndicator(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
