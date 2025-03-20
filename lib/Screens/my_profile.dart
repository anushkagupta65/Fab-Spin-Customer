import 'dart:convert';
import 'dart:io';
import 'package:fabspin/Screens/setting.dart';
import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Urls/urls.dart';
import '../tabs/custom_drawer.dart';
import 'notificaton_screen.dart';
import 'package:http_parser/http_parser.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _gst = TextEditingController();
  TextEditingController _loc = TextEditingController();
  String? _storedAddress;
  int? userId;
  String _mobile = '';
  String _address = '';

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _getUserId();
    _getAddressFromPreferences();
  }

  Future<void> _getAddressFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedAddress = prefs.getString('userAddress') ?? 'No address found';
      _loc.text = _storedAddress ?? 'No address found';
    });
  }

  Future<void> _updtadeProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(Urls.updateProfile);

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['user_id'] = userId.toString();
      request.fields['name'] = _name.text;
      request.fields['email'] = _email.text;
      request.fields['customer_gst'] = _gst.text;

      if (_image != null) {
        final fileSizeInMB = _image!.lengthSync() / (1024 * 1024); // Size in MB
        if (fileSizeInMB > 2) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image size must be less than 2 MB.')),
          );
          return;
        }

        request.files.add(await http.MultipartFile.fromPath(
          'image', _image!.path,
          contentType: MediaType('image', '*'), // Allows any image type
        ));
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${responseData.body}');

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        print('Profile Updated: $data');

        String mobile = data['User']['mobile'].toString();
        String email = data['User']['email'].toString();
        String name = data['User']['name'].toString();
        String userIdStr = data['User']['user_id'].toString();
        String gst = data['User']['customer_gst'].toString();

        await prefs.setString('mobile', mobile);
        await prefs.setString('email', email);
        await prefs.setString('name', name);
        await prefs.setString('userId', userIdStr);
        await prefs.setString('userGst', gst);

        print('SharedPreferences Updated.');

        setState(() {
          _loadUserData();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Updated.')),
        );

        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Setting()),
          );
        });
      } else {
        print('Failed request with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile update failed.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name.text = prefs.getString('name')!;
      _email.text = prefs.getString('email')!;
      _mobile = prefs.getString('mobile')!;
      _address = prefs.getString('userAddress')!;
      _gst.text = prefs.getString('userGst')!;
      print("_userName ... ${_name.text}");
      print("_userEmail ... ${_email.text}");
      print("_userPhone ... ${_mobile}");
      print("GST ... ${_gst.text}");
    });
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
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          )
                        : (profileImg != null && profileImg!.isNotEmpty
                            ? Image.network(
                                profileImg!,
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/images/Fabspin.png',
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: 140,
                                ),
                              )
                            : Image.asset(
                                'assets/images/Fabspin.png', // Placeholder image
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              )),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: InkWell(
                    onTap: () {
                      _pickImage();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black)),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Ionicons.person_outline),
                        SizedBox(width: 15),
                        Expanded(
                            child: TextField(
                          controller: _name,
                          decoration: InputDecoration(
                            hintText: "Name",
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black)),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Ionicons.phone_portrait_outline),
                        SizedBox(width: 2),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            _mobile,
                            style: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black)),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Ionicons.mail_open_outline),
                        SizedBox(width: 15),
                        Expanded(
                            child: TextField(
                          controller: _email,
                          decoration: InputDecoration(
                            hintText: "Email",
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        )),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black)),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Ionicons.document_attach_outline),
                        SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: _gst,
                            decoration: InputDecoration(
                              hintText: "GST",
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              'Back',
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          height: 60,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _updtadeProfile();
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              'Update',
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 15,
                              ),
                            ),
                          ),
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
