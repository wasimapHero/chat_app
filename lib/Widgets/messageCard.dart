// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/Dialogs/dialogs.dart';
import 'package:chat_app/screens/Dialogs/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Models/massage.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';


class MessageCard extends StatefulWidget {
  final Message_ message;

  MessageCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {


    bool isMe = APIs.current_User.uid == widget.message.fromId;
    

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessages() : _blueMessages(),
    );

  }

  // other user's message
  Widget _blueMessages() {


    // update the read status if the sender and receiver are different
    if (widget.message.readTime.isEmpty) {

      APIs.updateReadStatus(widget.message);
      print("readTime updated, ==${widget.message.readTime}===");
    }

    //

      return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        // blue message
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal:
                    widget.message.msgType == Type.text ? mq.width * 0.04 : 0,
                vertical:
                    widget.message.msgType == Type.text ? mq.width * 0.03 : 0),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.02),
            decoration: BoxDecoration(
                borderRadius: widget.message.msgType == Type.text
                    ? BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30))
                    : BorderRadius.circular(0),
                border: Border.all(color: Colors.lightBlueAccent),
                color: Color.fromARGB(255, 231, 246, 250)),
            child: widget.message.msgType == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    child: CachedNetworkImage(
                      height: mq.height * 0.25,
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => Container(
                        height: 5,
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),

          ),
        ),

        // read time section

        Container(

          padding: EdgeInsets.only(right: mq.width*0.04),
          child: Text(
            MyDateUtil.getFormattedTime(context: context, time: widget.message.sentTime)
            , style: TextStyle(fontSize: 13, color: Colors.black54),)
            ),
        
      ],
    );
  
  
  }
  



  // my message
  Widget _greenMessages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Row(
          children: [
            SizedBox(width: mq.width*0.04,),
            // one line if, without the bracket
            widget.message.readTime.isNotEmpty ?
            Icon(Icons.done_all_rounded, color: Colors.lightBlueAccent.shade400, size: 15,)
            : Icon(Icons.done_all_rounded, color: Colors.black54, size: 15,)   ,
            Container(
              margin: EdgeInsets.symmetric(horizontal: mq.width*0.01, vertical: mq.height*0.02),
              child: Text(
                MyDateUtil.getFormattedTime(context: context, time: widget.message.sentTime)
                , style: TextStyle(fontSize: 13, color: Colors.black54),)),
          ],
        ),
          //
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:  widget.message.msgType == Type.text ? mq.width*0.04 : 0, 
                                          vertical: widget.message.msgType == Type.text ? mq.width*0.03 : 0),
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.04, vertical: mq.height*0.02),
            decoration: BoxDecoration(
              borderRadius: widget.message.msgType == Type.text ? BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30), topLeft: Radius.circular(30))
                            : BorderRadius.circular(0),
              border: Border.all(color: Colors.lightGreen),
              color: Color.fromARGB(255, 223, 251, 235)
            ),
            child: widget.message.msgType == Type.text ?
            Text(widget.message.msg, style: TextStyle(fontSize: 15,  color: Colors.black87),)
            : ClipRRect(
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => CircularProgressIndicator(strokeWidth: 2,),
                        errorWidget: (context, url, error) => Icon(Icons.image, size: 70,),
                    ),
                                ),
          ),
        ),
        
      ],
    );
  }


  // edit copy delete and see the text by bottom sheet
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.grey.shade200,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            // 1st divider
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                  vertical: mq.height * 0.015, horizontal: mq.width * .4),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(8)),
            ),

            (widget.message.msgType == Type.text)
                ?
                // copy text
                _OptionItem(
                    icon: Icon(
                      Icons.copy_all_rounded,
                      color: Colors.blue.shade300,
                      size: 25,
                    ),
                    name: "Copy text",
                    onTap: () async {
                      await Clipboard.setData(
                              ClipboardData(text: widget.message.msg))
                          .then(
                        (value) {
                          Get.back();
                          Dialogs.showGetRawSnackbar('Text copied!', mq);
                        },
                      );
                    })
                : // save image
                _OptionItem(
                    icon: Icon(
                      Icons.download_rounded,
                      color: Colors.grey.shade400,
                      size: 25,
                    ),
                    name: "Save Image",
                    onTap: () async{
                     try {
                        // image er path msg te ache 
                    await GallerySaver.saveImage(widget.message.msg, albumName: 'Goppo-Shoppo').then((success) {
                      Get.back(); // to hide bottom sheet 
                      if (success != null && success) {
                        Dialogs.showGetRawSnackbar('Image Saved!', mq);
                      }
                    });
                     } catch (e) {
                       print('ErrorWhileSavingImage: $e');
                     }
                    }),
            if (isMe)
              Divider(
                color: Colors.black54,
                indent: mq.width * 0.05,
                endIndent: mq.width * 0.05,
              ),
            // edit text
            if (widget.message.msgType == Type.text && isMe)
              _OptionItem(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue.shade400,
                    size: 25,
                  ),
                  name: "Edit",
                  onTap: () {
                    // for hiding the bottom sheet
                    Get.back();
                    _messageUpdateDialog();
                  }),
                  if (isMe)
            // delete text
            _OptionItem(
                icon: Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.red.shade300,
                  size: 25,
                ),
                name: "Delete",
                onTap: () async{
                  await APIs.deleteMessage(widget.message).then((value) => Get.back(),);
                }),
            Divider(
              color: Colors.black38,
              indent: mq.width * 0.05,
              endIndent: mq.width * 0.05,
            ),
            // sent text
            _OptionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.blue.shade400,
                  size: 23,
                ),
                name:
                    "Sent at  ${MyDateUtil.getMessageTimeWithYear(context: context, time: widget.message.sentTime)}",
                onTap: () {}),
            // read text
            _OptionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.green.shade300,
                  size: 23,
                ),
                name: widget.message.readTime.isEmpty
                    ? "Read At: Not seen yet"
                    : "Read At:  ${MyDateUtil.getMessageTimeWithYear(context: context, time: widget.message.readTime)}",
                onTap: () {}),
            SizedBox(
              height: 15,
            ),
          ],
        );
      },
    );
  }
  
  void _messageUpdateDialog() {
    String updated_msg = widget.message.msg;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        title: Row(
            children: [
              Icon(Icons.messenger_outline_rounded, color: const Color.fromARGB(255, 175, 83, 255), size: 23,),
              Text("  Edit text"),
            ],
          
          ),
        content: TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
            initialValue: updated_msg,
            onChanged: (value) => updated_msg = value,
            decoration: InputDecoration(
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
            APIs.updateMessage(widget.message, updated_msg);
          },
          child: Text("Update", style: TextStyle(color: Colors.black87),),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 160, 93, 255), width: 2)
        ),),
        ],
      )
    );

  }}


// stateless widget---> to call " widget with parameters" repeatedly
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon,
      required this.name,
      required this.onTap}); // add {} and required with every item

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * 0.05,
            top: mq.height * 0.015,
            bottom: mq.height * 0.015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              "    $name",
              style: TextStyle(
                  color: Colors.black54, fontSize: 15, letterSpacing: 0.5),
            )),
          ],
        ),
      ),
    );
  }
}

