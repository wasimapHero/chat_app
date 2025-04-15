// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Models/chat_cartUserModel.dart';

import '../../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({
    Key? key,
    required this.user,
  }) : super(key: key);

  final Chat_cartUserModel user;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: mq.width * 0.6,
                height: mq.height * 0.35,
        child: Column(
          children: [
            // image and name top
          Container(
            child: Stack(
              children: [
                Container(
                  width: mq.width * 0.6,
                  height: mq.height * 0.3,
                  // image user
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: user.image!,
                    errorWidget: (context, url, error) =>
                        Icon(CupertinoIcons.person),
                  ),
                ),
                // name on top
                Positioned(
                    top: 0,
                    child: Container(
                      height: mq.height * 0.05,
                      width: mq.width * 0.8,
                      color: Colors.black54.withOpacity(0.5),
                      padding: EdgeInsets.all(9),
                      child: Text(
                        user.name!,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    )),
              ],
            ),
          ),
          Container(
            width: mq.width * 0.6,
                height: mq.height * 0.05,
            padding: EdgeInsets.all(10),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.message_outlined,
                  color: Colors.greenAccent.shade700,
                ),
                Icon(Icons.call, color: Colors.greenAccent.shade700),
                Icon(Icons.video_camera_back_outlined,
                    color: Colors.greenAccent.shade700),
                Icon(Icons.info_outline, color: Colors.greenAccent.shade700),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
