import 'dart:io';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/Dialogs/dialogs.dart';
import 'package:chat_app/screens/homeScreen.dart';
import 'package:chat_app/screens/home_bottomNav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({Key? key}) : super(key: key);

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {

    bool _obscureText = true;

    
  // login to google by clicking "login button"

  _loginButtonHandle()  { 
              // for showing progess bar
              Dialogs.showProgressBar(context);

              // signIn সফল হলে => 
              signInWithGoogle().then((user) async {

                  // for hiding progess bar
                    Navigator.pop(context);

                    if (user != null) {
                      print("\nUser email: ${user.user!.email}");
                    print("\nUser additionalUserInfo: ${user.additionalUserInfo}");


                            if ( await APIs.doesUserExists()) {
                              Get.to(HomeBottomNav());
                            } else {
                              await APIs.createUser().then((value) {
                                Get.to(LoginScreen2());
                              });
                            }
                    }

              })
              ;
   }

    Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
        // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['profile', 'email']).signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
      
    } catch (e) {
      print("signin error: $e");
      Dialogs.showSnackBar(context, "Something went wrong (Check Internet!)");
      return null;
    }
}


  @override
  Widget build(BuildContext context) {
   mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to Zeva Chat", style: TextStyle(fontWeight: FontWeight.w500),),
        
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFB342FF),width: 1))
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF010001),
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    const Text(
                      'Sign up',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF010101),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                 _emailInput(),
                const SizedBox(height: 15),
                _passwordInput(),
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Wrong password',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9B9B9B),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000101),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 52),
                _loginButton(),
                const SizedBox(height: 15),
                _googleLoginButton(),
                const SizedBox(height: 15),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Color(0xFF989898)),
                        ),
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(color: Color(0xFFB342FF), fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Handle sign up action
                            },
                        ),
                      ],
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
  
  Widget _emailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Email',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'contact@zava.com',
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E1E1), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E1E1), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E1E1), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 19),
          ),
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
  
  Widget _passwordInput() {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          obscureText: _obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEC6767), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEC6767), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEC6767), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 19),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
  
  Widget _loginButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Handle login action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFAF52DE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text(
            'Login',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF010101),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _googleLoginButton() {
     return Center(
       child: OutlinedButton(
        onPressed: () {
          // Handle Google login
          _loginButtonHandle();
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Color(0xFFE1E1E1), width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 17),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://cdn.builder.io/api/v1/image/assets/dcefbbff02f64240a48c0117ac19872c/c16a693df6475e801f23c39132dd5ceb9dd1c4f48eccde6abd5b3fddef68b125?apiKey=dcefbbff02f64240a48c0117ac19872c&',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 6),
            const Text(
              'Login with Google',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
           ),
     );
  }
}