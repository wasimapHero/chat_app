import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Widgets/profile_User.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/addUser.dart';
import 'package:chat_app/screens/home2.dart';
import 'package:chat_app/screens/morePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({Key? key}) : super(key: key);

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  int pageIndex = 1;



  final pages = [
    //  ProfileOfUser(user: APIs.curr_User_all_info),
    AddUser(),
     Home2(),
     MorePage()
  ];


  @override
  Widget build(BuildContext context) {
      mq = MediaQuery.of(context).size;
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar()
      
    );
  
  }
  
  Container buildMyNavBar() {
    return Container(
      margin: EdgeInsets.only(bottom: mq.height*0.05),
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
              
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.home_filled,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.widgets_rounded,
                    color: Colors.white,
                    size: 35,
                  )
                : const Icon(
                    Icons.widgets_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
         
        ],
      ),
    );
  }
  
    


}