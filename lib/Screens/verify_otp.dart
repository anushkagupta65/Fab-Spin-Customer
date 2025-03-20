import 'dart:convert';
import 'package:fabspin/Urls/urls.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomnavigation.dart';
import 'login_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String OTP;
  const VerifyOtpScreen(this.OTP);
  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String _otp = "";
  int? userId;
  TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
    });
  }

  Future<void> _verifyOtp() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID not found. Please register again.')),
      );
      return;
    }

    final url = Uri.parse(Urls.otpVerify);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'otp': _otp,
          'user_id': userId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("responseData inside verify otp  ${responseData}");
        if (responseData['Status'] == 'Success') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id', responseData['user_id']);
          await prefs.setString('mobile', responseData['mobile']);
          await prefs.setString('email', responseData['email']);
          await prefs.setString('name', responseData['name']);
          await prefs.setString(
            'userAddress',
            responseData['address']['house'] +
                ', ' +
                responseData['address']['landmark'] +
                ', ' +
                responseData['address']['address'],
          );
          print(responseData['name']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Bottomnavigation()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid OTP. Please try again.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again later.')),
        );
      }
    } catch (e) {
      if (_otp == widget.OTP.toString()) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bottomnavigation()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful')),
        );
      }
    }

    setState(() {
      _otp = "";
      _otpController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'OTP Verification',
          style: GoogleFonts.barlow(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Please enter OTP.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    'OTP has been sent to you on your mobile number',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSans3(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 1,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    controller: _otpController,
                    onChanged: (value) {
                      setState(() {
                        _otp = value;
                      });
                    },
                    onCompleted: (value) {
                      setState(() {
                        _otp = value;
                      });
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeFillColor: Colors.grey[200],
                      inactiveFillColor: Colors.grey[200],
                      selectedFillColor: Colors.grey[200],
                      activeColor: Colors.black,
                      inactiveColor: Colors.black,
                      selectedColor: Colors.black,
                    ),
                    cursorColor: Colors.black,
                    animationType: AnimationType.fade,
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                    child: Text(
                      'SUBMIT',
                      style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: 1,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
