// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Widgets/chatCard_User.dart';
import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/Dialogs/dialogs.dart';
import 'package:chat_app/screens/Dialogs/my_date_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/main.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ViewProfile_User_Info extends StatefulWidget {
  final Chat_cartUserModel user;

  ViewProfile_User_Info({
    Key? key,
    required this.user,
  }) : super(key: key);

  

  @override
  _ViewProfile_User_InfoState createState() => _ViewProfile_User_InfoState();
}

class _ViewProfile_User_InfoState extends State<ViewProfile_User_Info> {



  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name!)),
      // body
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
            
          child: Column(
            children: [
              SizedBox(width: mq.width, height: mq.height*0.03,),
              // pic of user show
              ClipRRect(
               borderRadius: BorderRadius.circular(mq.height *0.09),
               child: CachedNetworkImage(
               width: mq.height * .18,
               height: mq.height * .18,
               fit: BoxFit.cover,
               imageUrl: widget.user.image!,
               errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
                                ),
                       ),
              SizedBox(width: mq.width, height: mq.height*0.03,),
              // Email
              Text(widget.user.email!, style: TextStyle(color: Colors.black87, fontSize: 16),),
              SizedBox(width: mq.width, height: mq.height*0.04,),
              // About
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("About: ", style: TextStyle(color: Colors.black87, fontSize: 16),),
                  Text(widget.user.about!, style: TextStyle(color: Colors.black54, fontSize: 16),),
                ],
              ),
          
            
            ],
          ),
        ),
      ),
    
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Last Active at: 
            Text("Joined at: ", style: TextStyle(color: Colors.black87, fontSize: 16),), 
            Text("${widget.user.createdAt!.substring(0,10)}", 
                style: TextStyle(color: Colors.black54, fontSize: 16),)
          ],
        ),
     
    );
  
  
  }


}