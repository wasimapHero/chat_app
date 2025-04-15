import 'package:chat_app/main.dart';
import 'package:chat_app/screens/Auth/login2.dart';
import 'package:chat_app/screens/home2.dart';
import 'package:chat_app/screens/homeScreen.dart';
import 'package:chat_app/screens/home_bottomNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class Splash2 extends StatefulWidget {
  const Splash2({Key? key}) : super(key: key);

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
    @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 5000), () {

      if (FirebaseAuth.instance.currentUser != null) {
        Get.to(HomeBottomNav());
      } else {
        Get.to(LoginScreen2());
      }

      /// exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.white,  statusBarColor: Colors.white)
      );
      ///
      
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
     mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to Zeva"),
        
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                _buildImages(),
                _buildTitle(),
                _buildTermsAndPrivacy(),
                _buildStartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  

  Widget _buildImages() {
    return Padding(
      padding: const EdgeInsets.only(top: 105),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/splash_img_1.png',
            width: 147,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 11),
          Image.asset(
            'assets/images/splash_img_2.png',
            width: 120,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 73, 24, 0),
      child: Text(
        'Connect easily with your family and friends over countries',
        style: GoogleFonts.mulish(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTermsAndPrivacy() {
    return Padding(
      padding: const EdgeInsets.only(top: 106),
      child: Text(
        'Terms & Privacy Policy',
        style: GoogleFonts.mulish(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          'Start Messaging',
          style: GoogleFonts.mulish(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 187, 90, 235),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
          minimumSize: Size(mq.width*0.65, 0),
        ),
      ),
    );
  }


}