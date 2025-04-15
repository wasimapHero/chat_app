import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/Widgets/profile_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUser extends StatefulWidget {
  const AddUser({ Key? key }) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
   bool _isSearching = false;
    List<Chat_cartUserModel> list = [];
  List<Chat_cartUserModel> _searchLettersList = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              
            ],
          ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        constraints: const BoxConstraints(maxHeight: 180),
        child: Column(
          children: [
            _buildHeader(),
            // _buildStoryList(),
            // const Divider(height: 1, color: Color(0xFFEDEDED)),
            Expanded(
              child: IconButton(onPressed: () {
                _addChatUserDialog();
              }, icon: Icon(Icons.person_add_alt_1_rounded)),
            ),
            Expanded(child: Text(""),),
            Expanded(child: Text(""),),
          ],
        ),
      ),
    );
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