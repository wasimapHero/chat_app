// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Models/massage.dart';
import 'package:chat_app/screens/Dialogs/my_date_util.dart';

import 'package:chat_app/screens/chatScreen.dart';

import 'package:chat_app/screens/Dialogs/profile_Dialog.dart';
import 'package:chat_app/screens/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/main.dart';
import 'package:get/get.dart';

class ChatCardUser extends StatefulWidget {

  Chat_cartUserModel user;


  ChatCardUser({
    Key? key,
    required this.user,
  }) : super(key: key);

  

  @override
  _ChatCardUserState createState() => _ChatCardUserState();
}

class _ChatCardUserState extends State<ChatCardUser> {

 // for last message

  Message_? _last_message;


  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width*0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // color: Colors.transparent,
      // elevation: 0,
      child: InkWell(
        onTap: () {

          Get.to(ChatScreen(user: widget.user,));
        },
        
        
        child: StreamBuilder<QuerySnapshot<Map<String,
dynamic>>>(
          stream: APIs.getLastMessage(widget.user), 
          builder: (context, snapshot) {

             if (snapshot.hasData) {
               final data = snapshot.data!.docs;
             final _list = data.map((e) => Message_.fromJson(e.data())).toList() ?? [];
             if (_list.isNotEmpty) {
               _last_message = _list[0];
             }
             }



            return ListTile(
        

        // user's profile picture
        // leading: CircleAvatar(child: Icon(CupertinoIcons.person)),


        leading: InkWell(
          onTap: () {
            showDialog(context: context, builder: (_) => ProfileDialog(user: widget.user),);
          },
          child: ClipRRect(
          borderRadius: BorderRadius.circular(mq.height *0.09),
          // user's profile picture
                      child: CachedNetworkImage(
                          width: mq.height * .065,
                          height: mq.height * .065,
                fit: BoxFit.cover,
                imageUrl: widget.user.image!,
                errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
            ),

          ),
        ),

        // name
        title: Text(widget.user.name!),

        // last peer's sent message
        subtitle: Text(_last_message!=null ?

           _last_message!.msgType == Type.image ? 'Picture' :

           _last_message!.msgType == Type.image ? 'sent an image' :

        
         _last_message!.msg :  widget.user.about!, maxLines: 1,),

        // last sent time from peer
        trailing: _last_message==null ? null // show nothing if no message is sent
        : 
        _last_message!.readTime.isEmpty && _last_message!.fromId != APIs.current_User.uid ?
        // show if have unread message from peer id
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.greenAccent.shade400,
            borderRadius: BorderRadius.circular(10)
          ),
        ) 
        :  
        // message sent time from peer Id
        Text(MyDateUtil.getLastMessageTime(context: context, time: _last_message!.sentTime), style: TextStyle(color: Colors.black54),),
      );
          },)
      ),
    );
  }
}