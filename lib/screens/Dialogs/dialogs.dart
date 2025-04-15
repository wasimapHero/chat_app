import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';


class Dialogs {

  static void showSnackBar (BuildContext context, String msg) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), 
                    backgroundColor: Colors.blue.withOpacity(0.8), 
                    behavior: SnackBarBehavior.floating ,));

    // method 1 ____
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), 
                    backgroundColor: Colors.blue.withOpacity(0.8), 
                    behavior: SnackBarBehavior.floating ,));
    // method 2 ____
    // Get.snackbar(msg, '',snackPosition: SnackPosition.BOTTOM);
  }
  

  static void showGetRawSnackbar(String msg, Size mq) {
    Get.rawSnackbar(
                              messageText: Text(
                                msg,
                                style: TextStyle(color: Colors.black87),
                              ),
                              backgroundColor: const Color.fromARGB(255, 241, 250, 255),
                              snackPosition: SnackPosition.BOTTOM,
                              icon: Icon(
                                Icons.check_circle_rounded,
                                color: const Color.fromARGB(255, 110, 33, 243),
                              ),
                              borderColor: Colors.black54,
                              borderWidth: 1,
                              margin: EdgeInsets.only(left: mq.width*0.05, right: mq.width*0.05, bottom: mq.height*0.08),
                              borderRadius: 20,
                              animationDuration: Duration(milliseconds: 200),
                              shouldIconPulse: true,
                              forwardAnimationCurve: Curves.bounceOut);

  }

    static void showProgressBar (BuildContext context) {
    showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator()));
  }
}
