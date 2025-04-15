import 'dart:math';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Models/massage.dart';
import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:chat_app/Models/chat_cartUserModel.dart';


class ZegocloudVideoScreen extends StatefulWidget {
    final Chat_cartUserModel user;
      final Message_ message;
   ZegocloudVideoScreen({ Key? key, required this.user, required this.message, }) : super(key: key);


  @override
  _ZegocloudVideoScreenState createState() => _ZegocloudVideoScreenState();
}

class _ZegocloudVideoScreenState extends State<ZegocloudVideoScreen> {

  String userId = Random().nextInt(10000).toString();
  

  @override
  Widget build(BuildContext context) {
     bool isMe = APIs.current_User.uid == widget.message.fromId;


    return Text("");
  }
}

// return ZegoUIKitPrebuiltCall(
//     appID: 2083478944, 
//     appSign: 'd1b450abb9413109a0da7cda4ee2f9e8c1878fa25cbcacd018fcefae997df9b0', 
//     userID: userId,
//     userName: 'username$userId',
//     // callID: isMe ? widget.user.id.toString() : APIs.curr_User_all_info.id.toString(),
//     callID: 'call-id',
//     // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//     config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//         );