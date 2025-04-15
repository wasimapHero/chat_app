import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/Widgets/chatCard_User.dart';
import 'package:chat_app/Widgets/profile_User.dart';
import 'package:cuberto_bottom_bar/internal/cuberto_bottom_bar.dart';
import 'package:cuberto_bottom_bar/internal/tab_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
// final list = [];  // ei list jokhon data asce kina check korbo, tokhon use korbo
  // ar eta model use korar somoy:
  List<Chat_cartUserModel> list = [];
  List<Chat_cartUserModel> _searchLettersList = []; // search list dorkar ekadhik result (similar) dekhanor jonno
  bool _isSearching = false;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      print(" active kina status ber kora 'SystemChannels.lifecycle.setMessageHandler((message)': $message");

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
        child:   
    Scaffold(
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
            ) : Text("Zeva Chat"),
            actions: [
              
              
              // IconButton(onPressed: () {
              //   _addChatUserDialog();
              // }, icon: Icon(Icons.person_add_alt_1_rounded)),
              
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileOfUser(user: APIs.curr_User_all_info)));
              }, icon: Icon(Icons.person)),
            ],
          ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          children: [
            _buildHeader(),
            // _buildStoryList(),
            // const Divider(height: 1, color: Color(0xFFEDEDED)),
            Expanded(
              child: _buildChatList(),
            ),
          ],
        ),
      ),
      
    )
  ,
    ));
  
  
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 29, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Chats',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish',
            ),
          ),
          IconButton(onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: _isSearching ? Icon(Icons.clear_outlined) : Icon(Icons.search)),
        ],
      ),
    );
  }

  Widget _buildStoryList() {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        
        children: [
           Container(
      width: 56,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFADB5BD), width: 2),
              color: const Color(0xFFF7F7FC),
            ),
            child:ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          "assets/images/chatting-app.png",
          fit: BoxFit.cover,
        ),
      ),
          ),
          const SizedBox(height: 4),
          Text(
            "Rony Ahmed",
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontFamily: 'Mulish',
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    )
           
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return StreamBuilder(
            stream: APIs.getAllUsers(), 
            builder: (context, snapshot) {
              // builder er moddhe ar return er age code lekha jay
              switch (snapshot.connectionState) {
                // if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
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
            });
  }
  
    
  //   void _addChatUserDialog() {
  //   String email = '';

  //   Get.dialog(
  //     AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20)
  //       ),
  //       title: Row(
  //           children: [
  //             Icon(Icons.person_add, color: const Color.fromARGB(255, 149, 83, 255), size: 23,),
  //             Text("  Add user"),
  //           ],
          
  //         ),
  //       content: TextFormField(
  //         maxLines: null,
  //         keyboardType: TextInputType.multiline,
  //           onChanged: (value) => email = value,
  //           decoration: InputDecoration(
  //             hintText: "Email Id",
  //             prefixIcon: Icon(Icons.email_outlined, color: Colors.black54,),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(15)
  //             )
  //           ),
  //         ),


  //       actions: [
  //         // cancel button
  //         MaterialButton(onPressed: () {
  //           Get.back();
  //         },
  //         child: Text("Cancel", style: TextStyle(color: Colors.black45),),
  //         color: const Color.fromARGB(255, 245, 235, 252),),


  //         // update button
  //         MaterialButton(onPressed: () {
  //           Get.back();
  //           // APIs.updateMessage(widget.message, updated_msg);
  //         },
  //         child: Text("Add", style: TextStyle(color: Colors.black87),),
  //         shape: RoundedRectangleBorder(
  //           side: BorderSide(color: Color.fromARGB(255, 149, 85, 252), width: 2)
  //       ),),
  //       ],
  //     )
  //   );

  // }



 
}

