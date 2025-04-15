import 'dart:convert';


import 'dart:developer';

import 'dart:ffi';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/Widgets/chatCard_User.dart';
import 'package:chat_app/Widgets/profile_User.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/spalshScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// final list = [];  // ei list jokhon data asce kina check korbo, tokhon use korbo
  // ar eta model use korar somoy:
  List<Chat_cartUserModel> list = [];
  List<Chat_cartUserModel> _searchLettersList = []; // search list dorkar ekadhik result (similar) dekhanor jonno
  bool _isSearching = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    APIs.get_nd_store_userInfo();

    //permission neya
    //push token, active egulO variable e store kora
    //stored info firebase e update kora
    
    // 3 ta method call:
    // APIs.getPermissionOfNotification();
    // APIs.get_nd_store_userInfo();
    // APIs.updateActiveStatus()  --> niche
    APIs.getPermissionOfNotification();
    APIs.get_nd_store_userInfo();
    APIs.firebaseInit_forwardStatePopUp(context);
    APIs.setupInteractMessage_background_terminated_PopUp(context);


    // active kina status ber kora
    SystemChannels.lifecycle.setMessageHandler((message) {
      log(" active kina status ber kora 'SystemChannels.lifecycle.setMessageHandler((message)': $message");

      // resume -> online
      // pause -> offline/ inactive
      if(APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) APIs.updateActiveStatus(true);
      if (message.toString().contains('pause')) APIs.updateActiveStatus(false);
      }

      return Future.value(message);
    });

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
           return Future.value(false);
          } else {
           return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(

            // notification trigger icon for now
            // home button
            leading: IconButton(onPressed: ()  {

            }, icon: Icon(CupertinoIcons.home)),

            title: _isSearching ? TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Name, email..",
                hintStyle: TextStyle(color: Color.fromARGB(255, 179, 159, 253), fontWeight: FontWeight.w200, fontSize: 15),
              ), 
              autofocus: true,
              onChanged: (value) {
                
                // age add kora thakle segula baad dite
                _searchLettersList.clear();
        
                for (var i in list) {
                  if (i.name!.toLowerCase().contains(value.toLowerCase()) || i.email!.toLowerCase().contains(value.toLowerCase())) {
                     _searchLettersList.add(i); // mil hyoa doc gula add hobe search list e
                     
                  }
                  setState(() {
                      // sob gula mil i add hyoar por ekbare update kora search list ke
                      _searchLettersList;
                  });
                }
        
              },
            ) : Text("We Chat"),
            actions: [
              IconButton(onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: _isSearching ? Icon(Icons.clear_outlined) : Icon(Icons.search)),


              
              IconButton(onPressed: () {
                _addChatUserDialog();
              }, icon: Icon(Icons.person_add_alt_1_rounded)),
              

              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileOfUser(user: APIs.curr_User_all_info)));
              }, icon: Icon(Icons.person)),
            ],
          ),
        
        
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10),
            child: FloatingActionButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut().then((value) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen())));
            }, 
            // child: Icon(Icons.add_comment_rounded)
            child: Icon(Icons.logout)
            ),
          ),
        
          body: StreamBuilder(
            stream: APIs.getAllUsers(), 
            builder: (context, snapshot) {
              // builder er moddhe ar return er age code lekha jay
              switch (snapshot.connectionState) {
                // if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:

                  return Center(child: CircularProgressIndicator(),);

                  return Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),);

          
                // if some of the data is loaded / all of it loaded
                case ConnectionState.active:
                case ConnectionState.done:
                                
                // jokhon connection state thik ache, tokhon nicher moto data load koro:
          
                if (snapshot.hasData) {
                final data = snapshot.data?.docs;
                
                list = data?.map((e) => Chat_cartUserModel.fromJson(e.data())).toList() ?? [];
                // print("list[0]");
                // print(list[0].email);
          
          
          
          
                // evabe data firebase theke adoi ase kina check korba: (if er moddhe)
                // 
                // for (var i in data!) {
                //   print("\nPrint data coming from User Collection:\n ${i.data()}");
                //   list.add(i.data()['name']);
                //   print('Data: ${i.data()}');
                //   // print(jsonEncode(i.data()));
          
                // }
                //
              }
          
          
              }
          
          
              
          
              if (list.isNotEmpty) {
                return ListView.builder(
                itemCount: _isSearching ? _searchLettersList.length : list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder:  (context, index) {
                  return ChatCardUser(user: _isSearching ? _searchLettersList[index] : list[index],);
                  // return Text("Name: ${list[index]}"); // data asce kina dekhar jonno
            });
              } else {
                return Center(
                  child: Text("No data found!", style: TextStyle(fontSize: 30),),
                );
              }
            })
            ,
        ),
      ),
    );
  }
  

  

    void _addChatUserDialog() {
    String email = '';

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        title: Row(
            children: [
              Icon(Icons.person_add, color: const Color.fromARGB(255, 149, 83, 255), size: 23,),
              Text("  Add user"),
            ],
          
          ),
        content: TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: "Email Id",
              prefixIcon: Icon(Icons.email_outlined, color: Colors.black54,),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
              )
            ),
          ),


        actions: [
          // cancel button
          MaterialButton(onPressed: () {
            Get.back();
          },
          child: Text("Cancel", style: TextStyle(color: Colors.black45),),
          color: const Color.fromARGB(255, 245, 235, 252),),


          // update button
          MaterialButton(onPressed: () {
            Get.back();
            // APIs.updateMessage(widget.message, updated_msg);
          },
          child: Text("Add", style: TextStyle(color: Colors.black87),),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 149, 85, 252), width: 2)
        ),),
        ],
      )
    );

  }



  
}


// 