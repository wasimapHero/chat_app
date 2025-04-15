// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Widgets/messageCard.dart';


import 'package:chat_app/screens/Dialogs/my_date_util.dart';
import 'package:chat_app/screens/Dialogs/zegocloudVideo.dart';
import 'package:chat_app/screens/view_profile_User_Info.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/Models/massage.dart';
import 'package:chat_app/main.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  //
  final Chat_cartUserModel user;
  ChatScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  //

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // call message class ad create list of msg


  late List<Message_> _msgList = [];


  TextEditingController _sent_textController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  bool _showEmoji = false;
  // to check if images are uploading or not
  bool _isUploading = false;




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => FocusScope.of(context).unfocus(),
    
      
      child: PopScope(
        
    
        // if emoji button is shown and back button is pressed,
        // then at first, emoji button will be closed/hide
        // else, will go back to back page
        canPop: false,
    
        onPopInvoked: (_) {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return;
          }
    
          // some delay before pop
          Future.delayed(Duration(milliseconds: 300), () {
            try {
              if(Navigator.canPop(context)) Get.back();
            } catch (e) {
              log('ErrorPop: $e');
            }
          });
          
          },
        child: Scaffold(
          
          // app bar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          //
          backgroundColor: Color(0xFEF4F9F9),
    
          //
          body: SafeArea(
            child: Column(

              children: [
                Expanded(
                    child: StreamBuilder(
                  // ekhane widget.user holo: peer user
                  stream: APIs.getAllMessages(widget.user),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Text("No connection found");
                      case ConnectionState.active:
                      case ConnectionState.done:
                        //
                        // if(snapshot.hasData) {
                        //   final data = snapshot.data!.docs;
                        //   print('Data (message) : ${jsonEncode(data[0].data())}');
                        //   final msg = jsonEncode(data[0].data());
                        //   // Data (message) : {"msg":"hi hello bye","sent_time":"294865hjg","from_Id":"3845t7746","read_time":"zfghbhbn","msg_type":"image jpg","to_Id":"05846748678"}
                        //   return Text("data");
                        // } else {
                        //   return Text("snapshot has no data");
                        // }


                        

            
                        final data = snapshot.data!.docs;
                        _msgList = data
                                .map((e) => Message_.fromJson(e.data()))
                                .toList() ??
                            [];
            

                        if (_msgList.isNotEmpty) {
                          return ListView.builder(
                            // to show the last item always
                              reverse: true,
                              itemCount: _msgList.length,
                              // controller: _scrollController,
                              itemBuilder: (context, index) {
                                return MessageCard(message: _msgList[index]);
                              });
                        } else {
                          return Center(
                            child: Text(
                              "Hi! 👋",
                              style: TextStyle(fontSize: 30),
                            ),
                          );
                        }
                    }
                  },
                )),


            
                  // circular progress bar between input bar & messages
                  if(_isUploading)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFD7D7D7),
                        ),
                      ),
                    ),
                  ),
            
            

                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                      height: mq.height * 0.35,
                      child: EmojiPicker(
                        textEditingController: _sent_textController,
                        config: Config(
                            emojiViewConfig: EmojiViewConfig(
                          backgroundColor: Colors.transparent,
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          columns: 8,
                        )),
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {

    return Row(
      children: [
        IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )),
        ClipRRect(
          borderRadius: BorderRadius.circular(mq.width * 0.05),
          child: CachedNetworkImage(
            width: mq.width * .1,
            height: mq.height * .053,
            fit: BoxFit.fill,
            imageUrl: widget.user.image!, // peer user image
            errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // peer user name
            Text(
              "${widget.user.name}",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            Text(
              "Active 10m ago",
              style: TextStyle(
                  fontSize: 13, color: Color(0xFF7A7979)),
            ),
          ],
        )
      ],
    );
  }




  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: mq.height * 0.02, top: mq.height * 0.01, left: mq.width * 0.02, right: mq.width * 0.02),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mq.height * .5)),
              child: Row(
                children: [


                  // emoji button show

                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.black54,
                      )),

                      // text input taking bar
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: TextField(
                        scrollController: _scrollController,
                        contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                          return AdaptiveTextSelectionToolbar.editable(
                            anchors: editableTextState.contextMenuAnchors,
                            clipboardStatus: ClipboardStatus.pasteable, onCopy: () => editableTextState.copySelection(SelectionChangedCause.toolbar),
                            // to apply the normal behavior when click on cut
                            onCut: () => editableTextState.cutSelection(SelectionChangedCause.toolbar),
                            onPaste: () {
                                // HERE will be called when the paste button is clicked in the toolbar
                                // apply your own logic here
                      
                                // to apply the normal behavior when click on paste (add in input and close toolbar)
                                editableTextState.pasteText(SelectionChangedCause.toolbar);
                            }, 
                            onLookUp: () {},
                            // to apply the normal behavior when click on select all
                            onSelectAll: () => editableTextState.selectAll(SelectionChangedCause.toolbar), onSearchWeb: () {  }, onShare: () {  }, onLiveTextInput: () {  },
                            );
                        },
                        //
                        onTap: () {
                          setState(() {
                            if (_showEmoji) _showEmoji = !_showEmoji;
                          });
                        },
                        controller: _sent_textController,
                        keyboardType: TextInputType.multiline,
                        onTapOutside: (e) => FocusScope.of(context).unfocus(),
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Message",
                            hintStyle: TextStyle(color: Colors.black54)),
                      ),

                    ),
                  ),

                  // gallery theke pic send
                  IconButton(
                      onPressed: () async{
                        final ImagePicker picker = ImagePicker();
                        // Pick multiple images.
                        final List<XFile>? images = await picker.pickMultiImage(imageQuality: 70);

                        if (images != null) {

                          // upload to db one by one
                          for (var i in images) {
                            // log('image path:  ${image.name} -- mimeType: ${image.mimeType}');

                            // Get.snackbar('${image.name}', '${image.path}');


                            APIs.sendChatImage(widget.user, File(i.path));

                            setState(() =>_isUploading = true);

                            APIs.sendChatImage(widget.user, File(i.path));

                            setState(() =>_isUploading = false);

                          }
                        }
                      },
                      icon: Icon(
                        Icons.image_outlined,
                        color: Colors.black54,
                      )),

                      // camera theke pic send
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

                        if (image != null) {
                          // log('image path:  ${image.name} -- mimeType: ${image.mimeType}');

                          // Get.snackbar('${image.name}', '${image.path}');


                          APIs.sendChatImage(widget.user, File(image.path));

                          setState(() =>_isUploading = true);

                          APIs.sendChatImage(widget.user, File(image.path));

                          setState(() =>_isUploading = false);

                        }
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black54,
                      )),
           
        ]),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          
          //
          Container(
            width: mq.width * 0.1,
            child: MaterialButton(
              shape: CircleBorder(),
              padding: EdgeInsets.only(top: 9, bottom: 9, right: 5, left: 6),
              child: Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 17,
              ),
              color: Color(0xFF1DAB61),
              onPressed: () {
                if (_sent_textController.text.isNotEmpty) {
                  // msg + peer user er id pathacchi
                  APIs.sendMessage(

                      widget.user, _sent_textController.text.trim(), Type.text);
                      }

                  _sent_textController.text = '';

                  // message send korle jate scroll kore end auto dekhay
                  _scrollController.animateTo(
                      _scrollController.position.extentBefore,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut);
               
  }),
              
            ),
          
        ],
      ),
    );
  }
}
