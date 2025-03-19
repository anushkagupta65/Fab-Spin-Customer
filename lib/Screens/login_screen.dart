// import 'package:fabspin/Screens/verify_otp.dart';
// import 'package:fabspin/Urls/urls.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController mobileNumber = TextEditingController();
//     TextEditingController name = TextEditingController();
//     TextEditingController email = TextEditingController();
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//              const SizedBox(height: 50),
//           CircleAvatar(
//             radius: 90,
//             backgroundColor: Colors.white,
//             child: ClipOval(
//               child: Image.network(
//                 Urls.circularAvatarImg,
//                 width: 200,
//                 height: 200,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//           Text(
//             'Fabspin\nRefresh your style,\nRenew your confidence.',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.barlow(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 30),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: TextField(
//               controller: name,
//               keyboardType: TextInputType.phone,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               decoration: InputDecoration(
//                 hintText: 'Enter Your Full Name',
//                 hintStyle: const TextStyle(color: Colors.white70),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.3),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                     vertical: 15.0, horizontal: 20.0),
//               ),
//               style: GoogleFonts.barlow(color: Colors.white),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: TextField(
//               controller: email,
//               keyboardType: TextInputType.phone,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               decoration: InputDecoration(
//                 hintText: 'Enter Your Email Address',
//                 hintStyle: const TextStyle(color: Colors.white70),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.3),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                     vertical: 15.0, horizontal: 20.0),
//               ),
//               style: GoogleFonts.barlow(color: Colors.white),
//             ),
//           ),
//           const SizedBox(height: 20),
//            Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: TextField(
//               controller: mobileNumber,
//               keyboardType: TextInputType.phone,
//               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               decoration: InputDecoration(
//                 hintText: 'Enter Phone Number',
//                 hintStyle: const TextStyle(color: Colors.white70),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.3),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                     vertical: 15.0, horizontal: 20.0),
//               ),
//               style: GoogleFonts.barlow(color: Colors.white),
//             ),
//           ),
//            const SizedBox(height: 35),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => VerifyOtpScreen()),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: Colors.black,
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 120.0, vertical: 20.0),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: Text(
//               'G E T    O T P',
//               style: GoogleFonts.barlow(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // new code defined on 5 sept 2024 with api






import 'dart:convert';
import 'package:fabspin/Screens/terms_condition.dart';
import 'package:fabspin/Screens/verify_otp.dart';
import 'package:fabspin/Urls/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileNumber = TextEditingController();
  bool isChecked = false;

  Future<void> registerUser() async {
    final url = Uri.parse(Urls.registerUser);
    final response = await http.post(
      url,
      body: json.encode({
        "mobile": mobileNumber.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['Status'] == 'Success') {
        print("responseData inside login screen $responseData");

        await _saveUserId(responseData['user']['id']);
        mobileNumber.clear();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(
              responseData['user']['m_otp'].toString(),
            ),
          ),
        );
      } else {
        _showSnackBar('Registration failed. Please try again.');
      }
    } else {
      _showSnackBar('An error occurred. Please try again later.');
    }
  }

  Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _validateForm() {
    if (!isChecked) {
      _showSnackBar('You must accept the conditions to proceed.');
    } else if (mobileNumber.text.isEmpty) {
      _showSnackBar('Please enter your phone number.');
    } else {
      registerUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //const SizedBox(height: 50),
              Image.asset(
                'assets/icon/fabspinsplash.png',
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
              ),
              //const SizedBox(height: 15),
              Text(
                ' Think Dryclean,\nThink Fabspin',
                textAlign: TextAlign.center,
                style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: mobileNumber,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  hintStyle:  GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                style: GoogleFonts.barlow(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Wrap the text in GestureDetector to make it clickable
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Colors.black,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the terms and conditions page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  TermsAndConditionsPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Accept Terms & Conditions.",
                      style: GoogleFonts.sourceSans3(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 12,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'GET OTP',
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
