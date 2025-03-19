import 'package:fabspin/Screens/wallet_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../tabs/custom_drawer.dart';
import 'notificaton_screen.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

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
        color: Colors.white,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     opacity: 0.09,
        //     image: AssetImage("assets/images/bg.jpg"),
        //     fit: BoxFit.cover,
        //   ),),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Get To Know More About Us', style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),),
                Text('At Fabspin Dry Cleaner, we strive to provide an exceptional customer experience, from our meticulous cleaning processes to our convenient drop-off and pick-up services. Trust us to care for your garments with the same attention to detail and dedication that we’ve maintained for a quarter of a century. Our technicians are trained in the latest methods and use state-of-the-art Italian machinery, renowned for its precision and efficiency. This combination of expertise and advanced technology guarantees the best possible results for your clothes, whether it’s everyday wear, delicate fabrics, or special items like wedding gowns, velvet coats, suede jackets etc. We are also dedicated to sustainability. Our use of eco-friendly chemicals ensures that our cleaning processes are gentle on both your garments and the environment. This commitment to green practices underscores our dedication to responsible business operations.', style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 12,
                  //fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 20,),
                Text('Warm Words By Our Happy Customers', style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),),
                Text('Leveraging a skilled production crew with over 25 years of practical experience in India, FABSPIN promises to deliver high quality dry cleaning services. Production team is expert in operating drycleaning machines and equipment. Skilled in treating and removing stains from garments. Their vast knowledge about different types of fabrics and stain removal methods helps in cleaning of garments preventing damage.', style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 12,
                  //fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 20,),
                Text('Services Offered By Fabspin', style: GoogleFonts.sourceSans3(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),),
              Text('Leveraging a skilled production crew with over 25 years of practical experience in India, FABSPIN promises to deliver high quality dry cleaning services. Production team is expert in operating drycleaning machines and equipment. Skilled in treating and removing stains from garments. Their vast knowledge about different types of fabrics and stain removal methods helps in cleaning of garments preventing damage.', style: GoogleFonts.sourceSans3(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 1,
                fontSize: 12,
                //fontWeight: FontWeight.bold,
              ),),
              ],
            ),
          )
        ),
      ),
    );
  }
}
