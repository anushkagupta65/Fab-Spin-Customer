import 'dart:convert';
import 'package:fabspin/Screens/maps.dart';
import 'package:fabspin/Screens/updateaddress.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import '../tabs/custom_drawer.dart';
import 'notificaton_screen.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  List<String> _addressAll = [];
  String? _storedAddress;
  int? _selectedAddressIndex;
  List addresses = [];

  Future<void> fetchCustomerAddress(int? customerId) async {
    final url =
        Uri.parse('https://fabspin.org/api/get-customer-addresses/$customerId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['Status'] == 'Success') {
          addresses = data['addresses'] as List;

          setState(() {
            _addressAll = addresses.map((address) {
              final house = address['house'] ?? '';
              final landmark = address['landmark'] ?? '';
              final mainAddress = address['address'] ?? '';
              return '$house, $landmark, $mainAddress';
            }).toList();

            // Find default address
            final defaultAddressIndex =
                addresses.indexWhere((address) => address['default'] == 1);
            _selectedAddressIndex =
                defaultAddressIndex >= 0 ? defaultAddressIndex : null;
          });
        } else {
          print('Error: ${data['Text']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerAddress(userId);
  }

  void _onAddressSelected(String address) {
    setState(() {
      _storedAddress = address;
    });
  }

  Future<void> setDefaultAddress({
    required int customerId,
    required int addressId,
  }) async {
    final url = Uri.parse('https://fabspin.org/api/set-default-address');

    final body = {
      'customer_id': customerId.toString(),
      'address_id': addressId.toString(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['Status'] == 'Success') {
          print('Default address set successfully.');
          print(responseData);
        } else {
          print('Error: ${responseData['Text']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
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
          ),
        )),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
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
            child: Icon(Ionicons.notifications_outline, color: Colors.white),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MapScreen(onAddressSelected: _onAddressSelected),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Add Address',
                            style: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Text(
                    'Saved Address',
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      letterSpacing: 1,
                      fontSize: 15,
                    ),
                  ),
                  Expanded(child: Divider())
                ],
              ),
              SizedBox(
                height: 15,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final isSelected = _selectedAddressIndex == index;
                  final adress = addresses[index];
                  final addressID = adress['id'];
                  return GestureDetector(
                    onTap: () async {
                      await setDefaultAddress(
                          customerId: userId as int, addressId: addressID);
                      setState(() {
                        _selectedAddressIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 3,
                          )
                        ],
                        borderRadius: BorderRadius.circular(19.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.home,
                              color: isSelected ? Colors.white : Colors.grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                _addressAll[index],
                                style: GoogleFonts.sourceSans3(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSelected ? Colors.white : Colors.grey,
                                  letterSpacing: 1,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                InkWell(
                                  child: Text(
                                    'Edit',
                                    style: GoogleFonts.sourceSans3(
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey,
                                      letterSpacing: 1,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Updateaddress(
                                          onAddressSelected: _onAddressSelected,
                                          addressId: addressID.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.add,
                                        color: Colors.grey,
                                      )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
