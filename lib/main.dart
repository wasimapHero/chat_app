import 'package:chat_app/firebase_options.dart';

import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/homeScreen.dart';
import 'package:chat_app/screens/spalshScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import 'package:chat_app/screens/Auth/login2.dart';
import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/home_bottomNav.dart';
import 'package:chat_app/screens/homeScreen.dart';
import 'package:chat_app/screens/spalshScreen.dart';
import 'package:chat_app/screens/splash2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


@pragma('vm:entry-point')
Future<void> _firebaseBAckgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}


// Global object for accessing device screen size;
late Size mq;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initialize_Firebase();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      FirebaseMessaging.onBackgroundMessage(_firebaseBAckgroundHandler);
    return GetMaterialApp(
      // title: 'We Chat',
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.black),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          titleTextStyle: TextStyle(color:  Color.fromARGB(255, 255, 255, 255), fontSize: 19, fontWeight: FontWeight.normal),
          backgroundColor:  Color.fromARGB(255, 100, 87, 248)

        )
      ),
      debugShowCheckedModeBanner: false,
      // home: const HomeScreen(),

      home: FirebaseAuth.instance.currentUser != null ? HomeBottomNav() : Splash2(),

      // home: LoginScreen(),
    );
  }
}



_initialize_Firebase() async{
 await Firebase.initializeApp (
   options: DefaultFirebaseOptions.currentPlatform,
 );
} 