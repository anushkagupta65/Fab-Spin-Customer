import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../tabs/custom_drawer.dart';

class WalletHistory extends StatefulWidget {
  const WalletHistory({super.key});

  @override
  State<WalletHistory> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  List<dynamic> walletHistory = [];

  @override
  void initState() {
    super.initState();
    _getWalletHistory();
  }

  bool isLoading = false;

  Future<void> _getWalletHistory() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://fabspin.org/api/wallet-transactions');
    try {
      final response = await http.post(
        url,
        body: json.encode({"customer_id": userId}),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['transactions'] != null) {
        setState(() {
          walletHistory = responseData['transactions'];
        });
      } else {
        setState(() {
          walletHistory = [];
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        walletHistory = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Wallet History",
          style: GoogleFonts.sourceSans3(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Balance',
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 12,
                ),
              ),
              Text(
                "Rs. ${walletAmount}",
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(width: 20)
        ],
      ),
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: walletHistory.isEmpty
            ? Center(
                child: Text(
                  'No Wallet History',
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: walletHistory.length,
                  physics: NeverScrollableScrollPhysics(),
                  reverse: true,
                  itemBuilder: (context, index) {
                    final wallet = walletHistory[index];
                    final isEven = index % 2 == 0;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: isEven ? Colors.white : Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${wallet['service_names']}',
                                        style: GoogleFonts.sourceSans3(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${wallet['booking_code'].toString()}',
                                        style: GoogleFonts.sourceSans3(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                          letterSpacing: 1,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${wallet['created_at'].substring(0, 10)}',
                                        style: GoogleFonts.sourceSans3(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                          letterSpacing: 1,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Rs. ${wallet['amount'].toString()}',
                                        style: GoogleFonts.sourceSans3(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          letterSpacing: 1,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
