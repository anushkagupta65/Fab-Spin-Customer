import 'dart:convert';
import 'dart:ffi';
import 'package:fabspin/Screens/booking_confirmation.dart';
import 'package:fabspin/Screens/my_profile.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Urls/urls.dart';
import '../tabs/custom_drawer.dart';
import 'notificaton_screen.dart';

class SchedulePickup extends StatefulWidget {
  final int id;
  SchedulePickup({super.key, required this.id});

  @override
  State<SchedulePickup> createState() => _SchedulePickupState();
}

class _SchedulePickupState extends State<SchedulePickup> {
  DateTime currentDate = DateTime.now();
  String finalDate = '';
  String finalHour = '';
  List<dynamic> availableTimes = []; // List to store API response
  DateTime? selectedDate; // Track the selected date
  //DateTime? selectedTime;
  int _selectedValue = 1; // Fetch data based on the selected date and hour
  late double lat;
  late double long;
   int? storeId ;
  int? timeid;
  late String? mobile;
  late String addressId;
  int? userId;
  late List<DateTime> weekDates;
  int? exp_ser = 0;
  List<String> _addressAll = [];
  String? _storedAddress;
  int? _selectedAddressIndex;
  List addresses = [];



  Future<void> fetchTime() async {
    // Check if selected date is the current date
    bool isToday = selectedDate != null && selectedDate!.isAtSameMomentAs(currentDate);

    // Set finalHour based on current time if today, or a default time otherwise
    finalHour = isToday
        ? DateFormat('HH').format(DateTime.now().add(Duration(hours: 2)))
        : '06';

    if (finalDate.isNotEmpty && finalHour.isNotEmpty) {
      final response = await http.get(Uri.parse(
          'https://fabspin.org/api/check-available-time/$finalDate/$finalHour/pick'));

      if (response.statusCode == 200) {
        setState(() {
          availableTimes = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    }
  }


  Future<void> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    mobile = prefs.getString('mobile');
    print(userId);
    final url = Uri.parse(Urls.getUser);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': userId,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("responseData   $responseData");
        if (responseData['Status'] == 'Success') {
          print(responseData['customer']['lat']);
          print(responseData['customer']['long']);
          setState(() {
            addressId = responseData['customer']['id'].toString();
            lat = responseData['customer']['lat'];
            long = responseData['customer']['long'];
          });
          _checkStore();
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _checkStore() async {
    final url = Uri.parse(Urls.checkStore);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'latitude': lat, //28.6112125,
          'longitude': long //77.3628516,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("responseData   $responseData");

        if (responseData['Status'] == 'Success') {
          print(responseData['Text'].toString());
          print(responseData['store_id'].toString());
          setState(() {

              storeId = responseData['store_id'];
              print(responseData['Text']);
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> setDefaultAddress({
    required int customerId,
    required int addressId,
  }) async {
    final url = Uri.parse('https://fabspin.org/api/set-default-address');

    // Define the request body
    final body = {
      'customer_id': customerId.toString(),
      'address_id': addressId.toString(),
    };

    try {
      // Make the POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      // Handle the response
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['Status'] == 'Success') {
          print('Default address set successfully.');
          print(responseData);
          _getUser();
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


  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        int? selectedAddressIndex = _selectedAddressIndex; // Use local state for updates

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Draggable indicator
                        Container(
                          height: 5,
                          width: 50,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // Title
                        Text(
                          'Select Address',
                          style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        // Address List
                        Expanded(
                          child: ListView.builder(
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final isSelected = selectedAddressIndex == index;
                              final adress = addresses[index];
                              final addressID = adress['id'];

                              return GestureDetector(
                                onTap: () async {
                                  await setDefaultAddress(
                                      customerId: userId as int, addressId: addressID);
                                  setModalState(() {
                                    selectedAddressIndex = index;
                                    addressId = addressID.toString();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.black : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.home,
                                      color: isSelected ? Colors.white : Colors.grey,
                                    ),
                                    title: Text(
                                      _addressAll[index],
                                      style: GoogleFonts.sourceSans3(
                                        fontWeight: FontWeight.w400,
                                        color: isSelected ? Colors.white : Colors.grey,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? Icon(Icons.check, color: Colors.white)
                                        : Icon(Icons.add, color: Colors.grey),
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
                  // Confirm Pickup Button
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedAddressIndex != null) {
                          setState(() {
                            _selectedAddressIndex = selectedAddressIndex; // Update main state

                          });
                          print("Pickup Confirmed for address index $selectedAddressIndex");
                          confirmOrder(); // Close bottom sheet
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select an address to confirm.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Confirm Pickup',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }





  Future<void> confirmOrder() async {
    print(userId);
    print(storeId);
    print(widget.id);
    print(finalDate);
    print(timeid);
    print(mobile);
    print(addressId);
    print(exp_ser);

    final String apiUrl = 'https://fabspin.org/api/confirm-new-booking';
    Map<String, dynamic> body = {
      "user_id": userId,
      "store_id": storeId!=null ? storeId :0,
      "exp_ser": exp_ser,
      "service_type": [
        {"id": widget.id}
      ],
      "picdate": finalDate,
      "timeslot_id": timeid,
      "mobile": mobile,
      "address_id": addressId
      //"contact_person": mobile
    };

    if(timeid != null){
      try {
        // Make the POST request
        final response = await http.post(
          Uri.parse(apiUrl),
          body: json.encode(body), // Convert the body to a JSON string
          headers: {'Content-Type': 'application/json'},
        );
        // Check if the request was successful
        
        SharedPreferences pref = await SharedPreferences.getInstance();
        if (pref.getString('name') != null && pref.getString('userAddress') != null) {
          if (response.statusCode == 200) {
            // Order confirmed successfully
            print('Order confirmed: ${response.body}');
            final responseData = json.decode(response.body);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingConfirmation(
                    bookingId: responseData['booking_code'] ?? responseData['manual_booking_id'].toString(), event: 'Booking Successful', eventDesc: 'Booking Code:',
                  )),
            );
          } else {

            print(userId);
            // Handle the error
            print(
                'Failed to confirm order: ${response.statusCode} ${response.body}');
          }
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pleae Update your Profile For Bookings')),
          );
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
        }
        
        

      } catch (e) {
        // Handle any exceptions

        print('Error confirming order: $e');
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Select Time Slot.')));
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _checkStore();
    fetchCustomerAddress(userId);
    weekDates =
        List.generate(7, (index) => currentDate.add(Duration(days: index)));
    if (weekDates.isNotEmpty) {
      selectedDate = weekDates[0]; // Set the first date as selected by default
      finalDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

      if (selectedDate!.isAtSameMomentAs(currentDate)) {
        finalHour = DateFormat('HH')
            .format(DateTime.now().add(Duration(hours: 2)));// Use the current hour if today
      } else {
        finalHour = '06'; // Otherwise, use 6 AM as default hour
      }

      // Fetch available times for the default date
      fetchTime();
    }

    print('Got the id: ${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    // Generate a list of 7 dates starting from the current date

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text('FABSPIN', style: GoogleFonts.sourceSans3(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 20,
            //fontWeight: FontWeight.bold,
          ),),
        ),
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
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),),
        child: Column(
          children: [
            SizedBox(
              height: 75,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weekDates.length,
                itemBuilder: (BuildContext context, index) {
                  DateTime date = weekDates[index];
                  String formattedDate = DateFormat('EEE d MMM').format(date);
                  String dayOfWeek = DateFormat('EEE')
                      .format(date); // EEE for abbreviated weekday (Mon)
                  String dayOfMonth =
                      DateFormat('d').format(date); // d for day of the month (16)
                  String month = DateFormat('MMM')
                      .format(date); // MMM for abbreviated month (Sep)

                  return InkWell(
                    onTap: () async {
                      setState(() {
                        selectedDate = date; // Update selected date
                        finalDate = DateFormat('yyyy-MM-dd').format(date);

                        if (date.isAtSameMomentAs(currentDate)) {
                          // If the selected date is today, use the current hour
                          finalHour = DateFormat('HH').format(DateTime.now());
                        } else {
                          // Otherwise, use 6 AM as the default hour
                          finalHour = '06';
                        }

                        print(finalDate);
                        print(finalHour);
                        availableTimes
                            .clear(); // Clear available times when a new date is selected
                      });
                      // Fetch available times for the selected date and hour
                      await fetchTime();
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      //margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        color: selectedDate != null &&
                                date.isAtSameMomentAs(
                                    selectedDate!) // Change color if date is selected
                            ? Colors.black
                            : Colors.grey.withOpacity(0.1),
                        //borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          '$dayOfWeek-$dayOfMonth-$month', // Display the formatted date
                          style: GoogleFonts.sourceSans3(
                            //fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: selectedDate != null &&
                                    date.isAtSameMomentAs(
                                        selectedDate!) // Change text color if date is selected
                                ? Colors.white
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: 250,
              child: availableTimes.isNotEmpty
                  ? GridView.builder(
                      //scrollDirection: Axis.horizontal,
                      itemCount: availableTimes.length,
                      itemBuilder: (context, index) {
                        final time = availableTimes[index];
                        var wallet = double.parse(walletAmount);
                        assert(wallet is double);
                        print(wallet);

                        return InkWell(
                          onTap: () {
                            setState(() {
                              timeid = time[
                                  'id']; // Assign the selected time's ID to timeid
                            });
                            print('Selected time ID: $timeid');
                          },
                          child: Container(
                            width: 150,
                            //height: ,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            //margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              color:
                                  timeid == time['id'] // Change color if selected
                                      ? Colors.grey // Selected color
                                      : Colors.blueGrey
                                          .withOpacity(0.1), // Default color
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    availableTimes[index]['combine_time']
                                        .toString(), // Display each item from the API response
                                    style: GoogleFonts.sourceSans3(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  _selectedValue == 0 ? Container(color: Colors.transparent,)
                             :Text('10% Discount', style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontSize: 12,
                                    //fontWeight: FontWeight.bold,
                                  ),)

                                ],
                              ),
                            ),
                          ),
                        );
                      }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    )
                  : Center(child: Text('Select Date')),
            ),


            Spacer(),

              // _selectedValue == 0 ? Container(color: Colors.transparent,)
              // :
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Colors.grey,
              //       border: Border.all(color: Colors.black)
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
              //       child: Text("10% off on all Orders", ),
              //     ),
              //   ),
              // ),
              //


            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                      child: RadioListTile(
                        activeColor: Colors.black,
                        tileColor: Colors.white,
                        title:
                        Text('Express Service', style: GoogleFonts.sourceSans3(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontSize: 15,
                          //fontWeight: FontWeight.bold,
                        ),), // Display the title for option 1
                        value: 0, // Assign value 1 for Express Service
                        groupValue: _selectedValue, // Track the selected option
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value as int; // Update the selected value
                            exp_ser = 1; // Set express service to 1
                            print('Selected Express Service');
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                      child: RadioListTile(
                        activeColor: Colors.black,
                        tileColor: Colors.white,
                        title:
                        Text('Normal Service', style: GoogleFonts.sourceSans3(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontSize: 15,
                          //fontWeight: FontWeight.bold,
                        ),), // Display the title for option 1
                        value: 1, // Assign value 0 for Normal Service
                        groupValue: _selectedValue, // Track the selected option
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value as int; // Update the selected value
                            exp_ser = 0; // Set express service to 0 (Normal Service)
                            print('Selected Normal Service');
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),


            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () async {
                   //confirmOrder();
                  await fetchCustomerAddress(userId); // Fetch the addresses first
                  if(timeid != null){
                    if (addresses.isNotEmpty) {
                      _showAddressBottomSheet(context); // Show bottom sheet

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No addresses available')),
                      );
                    }
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please Select Time Slot.')));
                  }



                  
                  // if(storeId == null){
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: const Text('Store not found'),
                  //           content: Text('Service Not Available Near You'),
                  //           actions: [
                  //             Center(
                  //               child: TextButton(
                  //                   child:  Text('OK', style: TextStyle(color: Colors.black),),
                  //                   onPressed: () {
                  //                     // Perform action on OK press
                  //                     Navigator.of(context).pop(); // Close the dialog
                  //                   }
                  //                   ),
                  //             )
                  //           ],
                  //         );
                  //       });
                  // }else{
                  //   confirmOrder();
                  // }
                },
                child: Container(
                  height: 60,
                  color: Colors.black,
                  child: Center(
                    child: Text('Schedule',
                        style: GoogleFonts.sourceSans3(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 15,
                          //fontWeight: FontWeight.bold,
                        ),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
