import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fabspin/Screens/home_page.dart';
import 'package:fabspin/Screens/my_profile.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../Urls/urls.dart';
import '../tabs/custom_drawer.dart';
import 'package:http_parser/http_parser.dart';

import 'notificaton_screen.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String _currentText = "";
  final List<String> items = [
    'Query',
    'Feedback',
    'Complaints',
  ];
  String? selectedValue;
  bool isSelected = false;
  final message = TextEditingController();

  Future<void> call() async {
    final Uri telUri = Uri(scheme: 'tel', path: '8588882929');

    // Request permission
    final status = await Permission.phone.request();

    if (status.isGranted) {
      try {
        if (await canLaunchUrl(telUri)) {
          await launchUrl(telUri);
        } else {
          throw 'Could not launch dialer';
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Phone permission denied');
    }
  }

  File? _image;  // Variable to store the selected image

  final ImagePicker _picker = ImagePicker();  // Image picker instance

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }
  
  // Future<void> contactUs()async{
  //   final pref = await SharedPreferences.getInstance();
  //   final url = Uri.parse(Urls.contactUS);
  //   try{
  //
  //     final response = await http.post(url, body: json.encode({
  //       'full_name' : pref.getString('name'),
  //       'email' : pref.getString('email'),
  //       'message' : message.text,
  //       'mobile' : pref.getString('mobile'),
  //       'types' : selectedValue.toString(),
  //       'image' : ,
  //
  //     }),
  //     headers: {'Content-Type' : 'application/json'},
  //     );
  //     print(response.body.toString());
  //     if(response.statusCode == 201){
  //       final responseData = json.decode(response.body);
  //       print("Contact Us: $responseData");
  //     }
  //
  //   }catch(e){
  //     print("Error: $e");
  //   }
  //
  // }
  Future<void> contactUs() async {
    final pref = await SharedPreferences.getInstance();
    final url = Uri.parse(Urls.contactUS);

    try {
      var request = http.MultipartRequest('POST', url);

      // Adding text fields
      request.fields['full_name'] = await pref.getString('name') ?? 'Name';
      request.fields['email'] = await pref.getString('email') ?? 'Email';
      request.fields['message'] = message.text;
      request.fields['mobile'] = await pref.getString('mobile') ?? '';
      request.fields['types'] = selectedValue.toString();

      // Adding the image file if available
      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image', _image!.path,
          contentType: MediaType('image', 'jpeg'), // Adjust according to your image format
        ));
      }

      // Sending the request
      final response = await request.send();

      // Handle the response
      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        print("Contact Us: $responseData");
        showDialog(context: context, builder: (context){
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("${selectedValue} Submitted"),
            actions: [
             Center(
               child: InkWell(
                 onTap: (){
                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Home()), (Route<dynamic> route) => false);
                 },
                 child: Container(
                   decoration: BoxDecoration(
                     color: Colors.black,
                     borderRadius: BorderRadius.circular(5),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text("Okay", style: TextStyle(color: Colors.white),),
                   ),
                 ),
               ),
             )
            ],
                      );
        });
      } else {
        showDialog(context: context, builder: (context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Please update your Profile"),
          actions: [
            Center(
              child: InkWell(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MyProfile()), (Route<dynamic> route) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Okay", style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            )
          ],
        );
        });
        print("Error: Server responded with status code ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
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
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              //color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 35),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint:  Row(
                      children: [
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Select a service',
                            style: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 15,
                              //fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: GoogleFonts.sourceSans3(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  letterSpacing: 1,
                                  fontSize: 15,
                                  //fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                        isSelected = true;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.white,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: WidgetStateProperty.all<double>(6),
                        thumbVisibility: WidgetStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
              child: Card(
                elevation: 2.5,
                shadowColor: Colors.grey,
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: message,
                    decoration: InputDecoration(
                      hintText: isSelected == true
                      ? ""
                      :"Dear Customer, we value your feedback and suggestions. For any queries, complaints or feedback, please feel free to write to us and we will get back to you.",
                      hintStyle: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        letterSpacing: 1,
                        fontSize: 12,
                        //fontWeight: FontWeight.bold,
                      ),

                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    maxLength: 255,
                    // inputFormatters: [
                    //   LengthLimitingTextInputFormatter(1000),
                    // ],
                    onChanged: (text) {
                      setState(() {
                        _currentText = text;
                      });
                    },
                  ),
                ),
              ),
            ),
        SizedBox(height: 20,),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.05,),
        //   child: Text(
        //     " ${_currentText.length}/1000",
        //     style: TextStyle(color: Colors.black),
        //   ),),


            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Icon(
                    Ionicons.image_outline,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _image != null
                ? Expanded(
                  child: Image.file(
                                _image!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                )
                : Text('Select Image', style: GoogleFonts.sourceSans3(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: 1,
              fontSize: 15,
              //fontWeight: FontWeight.bold,
            ),),


            SizedBox(height: 70,),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact Us ", textAlign: TextAlign.start, style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                  letterSpacing: 1,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),),
                Text('Email ID: Info@fabspin.com', style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),),
                Text('Phone No. 8588882929', style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),),
              ],
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
                          call();
                        },
                        child: Container(
                          child: Center(child: Text('Call', style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold,
                          ),)),
                          height: 60,

                          color: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: (){
                          contactUs();

                        },
                        child: Container(
                          child: Center(child: Text('Send', style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold,
                          ),)),
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
}
