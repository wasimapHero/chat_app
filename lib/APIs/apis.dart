
import 'dart:io';

import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/Models/massage.dart';
import 'package:chat_app/Widgets/chatCard_User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/Models/massage.dart';
import 'package:chat_app/screens/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class APIs {
  // for firebase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for firebase firestore
  static FirebaseFirestore cloud_firestore = FirebaseFirestore.instance;

  // for firebase firestore
  static FirebaseStorage firebase_storage = FirebaseStorage.instance;

  // firebase theke login info -> current User ke and tar userId retrive, jeta matro login korlo



  // to get current user
  static User get current_User => auth.currentUser!;

  // for accessing Firebase Messaging (push notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // to get access  server key
  static String accessServerKey = '';

  // to store self info
  static late Chat_cartUserModel curr_User_all_info;
  // to store current_User's doc e rakha baki info in a global variable "curr_User_all_info"

  // taking permission to send notification from app settings
  static void getPermissionOfNotification() async {
    NotificationSettings settings = await fMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User denied permission");
      Get.snackbar('Notification permission denied',
          'Please allow notifications to receive updates',
          snackPosition: SnackPosition.BOTTOM);
      Future.delayed(
          Duration(seconds: 1),
          () =>
              AppSettings.openAppSettings(type: AppSettingsType.notification));
    }
  }

  // push Notification er jonno device token get er method
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        curr_User_all_info.pushToken = t;
        log('push token: $t');
      }
    });
  }

// get access server key to use postman
  static Future<String> getAccessServerKey_() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "chat-app-9b76b",
          "private_key_id": "6af999100e251c970cc3c75158f27cfcbac6141b",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC8I7XrKAMumWO/\ngtAKAI1/JX40hIrBicvx7Fc5MG3sQrCYlp7nXv57/KTXmnUZ4SYxVaHUAwilakg+\nuRxNkTdaP5qSO8xRJCckF0sEFX93TWnIiCHwSKv0SZKoHMbs1eKda2eK5bFBUbKx\no9Uw2oYXZrma905zIjRpEMfIRw9mBPFWxgBdi4L30OXWnD2OrNwMQRw8rB4+Bs+g\nPLvbhBm2RkgWV1VbDxQ95bwPjtaQ7k+2F6KERXCa7FeJSoQ53Pgks6yxw0DkYrv5\nW9CeoC6QUbG8oiff6AJFxn+NxudEqAaBrPHhefeoPQrxnaKAM1rjF7WKt10wY6kX\nzCaZ07hZAgMBAAECggEAAjYAjnW8aoDxS/qwu4Vbzv7fok9dGr7QpOmsRrxGdmx8\nNcwuAYsQvjVEXKebMQV/1ObsOBkcXLvzLbra1cswlYDCLhjCIxaj18fm9kfTD9Gw\nPg6M042PE8JaP7EtjJ1LhKJn/O5hFw2WO4Hbi1pDZtAAELhPoDO/3kI3uXyi9jBw\ngP+dVeUFYJapWAPTUHtyXGNIMnOtPWvWgpLYkyCE7cWEPDzrMUm6eLi4cMQ2QRwl\nK8qdqNg13tlaYAQDGwn457JbIcsQhvHBrm2iL/kWT/2x+BlN+NwsaX5w1VSIC2/1\nzjhILYZewH2XdBghg+tjddT0/gihxZExQXFGSXRveQKBgQDJiCb/i8bK6N+ZONeL\n9WRV51+jtyX8qV6Fl/extmRhk7EI58X/dNAq3+Rax0kUDV5C1qW3xmpFz58bgh6z\nkHYZ50JtqXg3iIIxThPUS4MGkM9j6jp0Gk5mRCNTUmtxOmb4jyIHBa1SKMAP/7hv\nJtHCnlpuUwrY4BbBzEuJFrBv9QKBgQDu/PNuc5T8N+zVnYu+oEmg9PfhF9HotV9Z\n5+ix9VaoI4r+47o+STcRxRhRHC3uZNl4wZmnjjNYwXok6i3vcl1NeyAy2bFApPca\nUDX/cm8bkAsK6aMfP0OKDon32Er+Y1WjPndI4USay/2/KaeBOUgYf/0Z52oaNpto\nYsKTL+jcVQKBgESng1GPFnvNdU7HVHazdCjnl2c4X1KBiFfOe20pC21KWQcFnif2\nbWwNtcdPGJAiNbhjUzUV/OInZraCT18wmWsdoz2ke/W/JUsSpCKwTsSP1HbfNmaT\nB55DHB2oeD2sfaOzbw4hWvggNb29ieEjwlWgiIII/CsBu/7tT9Y1yol5AoGAL1gP\nBYeCMUEG+v5966KnU2qUHJRycg5UOGRX1cFLjH2WEI6em643aZ7JBXB2rO5vopt/\nzBDAnUme3+dAeFoIn8vPgiNcGPlVNnJDcDqERkqP1XaZaRxITfY5YM8JdEHLek5q\npRZzV9MnjpI667+kR647PsF4ZH8C5HgEIdJw6A0CgYBUEV8c7yzkfe2bfKbTO+qe\nrwxoncy7u/PB/gYe6LHTDyPEdeUnJZ/G29SvD+41qV4/vGW4cc07ohAAwR52qP4v\n+gFZI/GSrkV0xAI7hbNqEiqlXMD7yuMK9Wc9tTbJJv3M2S3c6p1tAqvInRa5OKoJ\nFDbvgnXZlzpKTQOX9ocwQQ==\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-2tivy@chat-app-9b76b.iam.gserviceaccount.com",
          "client_id": "103876556179055153377",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-2tivy%40chat-app-9b76b.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final accessServerKey = client.credentials.accessToken.data;

    return accessServerKey;
  }

  // to send notification
  static Future<void> sendNotification(User giverUser,
      Chat_cartUserModel peerUser, String accessServerKey, String msg) async {
    accessServerKey = await APIs.getAccessServerKey_();
    print('AccessServerKey is: $accessServerKey');
    try {
      final body = {
        "message": {
          "token": peerUser.pushToken,
          "notification": {"body": msg, "title": giverUser.displayName}
        }
      };
      final res = await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/chat-app-9b76b/messages:send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessServerKey'
          },
          body: jsonEncode(body));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      log('\n sendPushNotificationError: $e');
    }
  }

// plugin neya
  static final FlutterLocalNotificationsPlugin _fluLocNotifPlugin =
      FlutterLocalNotificationsPlugin();

  // for forward state notification pop up : method ->
  static void firebaseInit_forwardStatePopUp(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        initLocalNotification(context, message); //-------method 1
        showNotificationPopUp(message); //--------method 2
      }

      // print notification to check if it's going before showing in app
      if (kDebugMode) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
      // ios forward handle diff:
      if (Platform.isIOS) {
        iosForegroundMessaging();
      }
    });
  }

  static Future iosForegroundMessaging() async {
    await fMessaging.setForegroundNotificationPresentationOptions();
  }

  //------method 1
  static Future<void> initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    // taking initializationSettings by merging android and ios:
    final androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    final iOSsettings = DarwinInitializationSettings();
    final initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSsettings);
    await _fluLocNotifPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (payload) {
        handleMessageToGoHomeScreen(context, message);
      },
    );
  }

  static Future<void> handleMessageToGoHomeScreen(
      BuildContext context, RemoteMessage message) async {
    Get.to(HomeScreen());
  }

  //-----------method 2
  static Future<void> showNotificationPopUp(RemoteMessage message) async {
    // AndroidNotificationChannel(id, name)
    final channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString());
    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name),
        iOS: DarwinNotificationDetails());
    Future.delayed(
      Duration.zero,
      () {
        _fluLocNotifPlugin.show(0, message.notification!.title.toString(),
            message.notification!.body.toString(), notificationDetails,
            payload: "mydata");
      },
    );
  }

  // for background & terminated state notification pop up : method ->
  static Future<void> setupInteractMessage_background_terminated_PopUp(
      BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessageToGoHomeScreen(context, message);
    });
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message != null && message.data.isNotEmpty) {
          handleMessageToGoHomeScreen(context, message);
        }
      },
    );
  }


  static Future<bool> doesUserExists() async {
    return (await cloud_firestore
            .collection('users')
            .doc(current_User.uid)
            .get())
        .exists;
    // get() diye uid sombilito doc collect korlo.
    // doc pele return true; na pele false pathabe.
  }




  static Future<void> get_nd_store_userInfo() async {
    await cloud_firestore
        .collection('users')
        .doc(current_User.uid)
        .get()


        .then((user) async {

      // user ta holo current user er doc file
      if (user.exists) {
        curr_User_all_info = Chat_cartUserModel.fromJson(user.data()!);
        // kintu user er sob data json obj e ache bole convert korte holo



        await getFirebaseMessagingToken();

        // setting user status active
        APIs.updateActiveStatus(true);


        print("Current User's data: ${user.data()}");
      } else {
        createUser().then((value) => get_nd_store_userInfo());
      }
    });
  }

  static Future<void> createUser() async {
    // Now time get
    final time = DateFormat.jm().format(DateTime.now()).toString();
    // final formatted_Time = DateFormat.jm(time).toString();



    final newUserData = Chat_cartUserModel(
      about: "Lovely Runner💜💜",
      email: current_User.email,
      id: current_User.uid,
      image: current_User.photoURL,
      isOnline: true,
      lastActive: time,
      createdAt: current_User.metadata.creationTime.toString(),
      name: current_User.displayName,
      pushToken: "",
    );
    // created at: current_User.metadata.creationTime.toString()


    await cloud_firestore
        .collection('users')
        .doc(current_User.uid)
        .set(newUserData.toJson());
    // je login korlo, tar info sathe sathe firebase er cloudstore e gelo. json hisebe.
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return cloud_firestore
        .collection('users')
        .where('id', isNotEqualTo: current_User.uid)
        .snapshots();
  }

  static Future<void> updateProfileInfo() async {
    await cloud_firestore.collection('users').doc(current_User.uid).update(
        {'name': curr_User_all_info.name, 'about': curr_User_all_info.about});
  }

  // update profile pic
  static Future<void> updateProfilePicture(File file) async {
    // path of storage image file:
    // userUid.jpg inside profile_picture folder
    // .jpg ba .peg extension pete:
    final extension = file.path.split('.').last;
    print('Extension: $extension');
    final ref = await firebase_storage
        .ref()
        .child('profile_picture/${current_User.uid}.$extension');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$extension'))
        .then((p0) {
      print('Data Transferred ${p0.bytesTransferred / 1000} kb');
    });

    // url niye update kora firebase cloud store e
    curr_User_all_info.image = await ref.getDownloadURL();

    await cloud_firestore
        .collection('users')
        .doc(current_User.uid)
        .update({'image': curr_User_all_info.image});
  }



  // get userInfo to show active or not
  static Stream<QuerySnapshot<Map<String, dynamic>>> getPeerUserInfo(
      Chat_cartUserModel chatUser) {
    return cloud_firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id) //chatUser is always => peer user
        .snapshots();
  }

  // update current user's last active info
  static Future<void> updateActiveStatus(bool isOnline) async {
    await cloud_firestore.collection('users').doc(current_User.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': curr_User_all_info.pushToken
    });
  }


  //**************************  Chat related APIs  ******************************* */

  //  chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  ///  useful for getting a conversation id
  ///  The hashCode property simply returns a number.So, lets say two users A and B are chatting,
  ///  so in order to fetch messages between A(eg, hashCode=11) and B(eg, hashCode=22), this has to be stored in the same firestore collection,
  ///  for that we need a unique id(groupChatId). If we were to create groupChatId(here groupChatId is used as the key for the firestore collection) simply by
  ///  '$curentId-$peerId' groupChatId would be 11-22 for A and 22-11 for B, which would result in two collections. Instead if we use the logic of:
  //   if (currentId.hashCode <= peerId.hashCode) {
  //      groupChatId = '$currentId-$peerId';
  //   } else {
  //      groupChatId = '$peerId-$currentId';
  //   }
  ///  groupChatId will be 11-22 for both A and B, hence the same firestore collection can be used to write and read from.
  ///
  static String getConversationId(String id) => current_User.uid.hashCode <=
          id.hashCode
      ? '${current_User.uid}_$id'
      : '${id}_${current_User.uid}'; // এখানে id হলো peerId, আর current_User.uid হলো currentId

  // to get all messages of a specific conversation from cloudstore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      Chat_cartUserModel chatuser) {
    return cloud_firestore
        .collection(
            'chats/${getConversationId(chatuser.id.toString())}/messages')

            .orderBy('sent_time', descending: true)

        .orderBy('sent_time', descending: true)

        .snapshots();
    // chatuser is: peer user
  }

  // for sending message
  static Future<void> sendMessage(
      Chat_cartUserModel chatuser, String msg, Type type) async {
    // chatuser is: peer user
    // message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // make string msg to a modeled message


    Message_ message = Message_(

        msg: msg,
        sentTime: time,
        fromId: current_User.uid,
        readTime: '',
        msgType: type,
        toId: chatuser.id.toString());
    final ref = cloud_firestore.collection(
        'chats/${getConversationId(chatuser.id.toString())}/messages');

    ref.doc(time).set(message.toJson());
  }



  // update read status of message
  static Future<void> updateReadStatus(Message_ message) async {

    cloud_firestore
        .collection('chats/${getConversationId(message.fromId)}/messages')
        .doc(message.sentTime)
        .update(
            {'read_time': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // to get only last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      Chat_cartUserModel chatuser) {
    return cloud_firestore
        .collection(
            'chats/${getConversationId(chatuser.id.toString())}/messages')
        .orderBy('sent_time', descending: true)
        .limit(1)
        .snapshots();
    // chatuser is: peer user
  }

  // to upload image of chat into database
  static Future<void> sendChatImage(
      Chat_cartUserModel chatUser, File file) async {
    // path of storage image file:
    // userUid.jpg inside profile_picture folder
    // .jpg ba .peg extension pete:
    final extension = file.path.split('.').last;
    print('Extension: $extension');

    final ref = await firebase_storage.ref().child(
        'images/${getConversationId(chatUser.id.toString())}/${DateTime.now().millisecondsSinceEpoch}.$extension');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$extension'))
        .then((p0) {
      print('Data Transferred ${p0.bytesTransferred / 1000} kb');
    });

    // url niye update kora firebase cloud store e
    final imageUrl = await ref.getDownloadURL();

    await sendMessage(chatUser, imageUrl, Type.image);
  }



  // delete message
  static Future<void> deleteMessage(Message_ message) async {
    await cloud_firestore
        .collection('chats/${getConversationId(message.toId)}/messages')
        .doc(message.sentTime)
        .delete();
    if (message.msgType == Type.image) {
      await firebase_storage.refFromURL(message.msg).delete();
    }
  }

  // update message
  static Future<void> updateMessage(Message_ message, String updated_msg) async {
    await cloud_firestore
        .collection('chats/${getConversationId(message.toId)}/messages')
        .doc(message.sentTime)
        .update({'msg': updated_msg});
  }

}
