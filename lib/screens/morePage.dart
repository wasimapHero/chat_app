import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Widgets/profile_User.dart';
import 'package:chat_app/screens/Auth/login2.dart';
import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/home2.dart';
import 'package:chat_app/screens/splash2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MorePage extends StatefulWidget {
  MorePage({
    Key? key,
  }) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  bool _isLightTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // notification trigger icon for now
        // home button
        leading: IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.home)),
        title: Text("Zeva Chat"),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profileSection(),
            const SizedBox(height: 8),
            MenuItem(
              icon: Icons.account_circle,
              title: Text(
                'Account',
                style: const TextStyle(
                  color: Color(0xFF0F1828),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                // Handle account tap
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileOfUser(user: APIs.curr_User_all_info)));
              },
            ),
            MenuItem(
              icon: Icons.chat_bubble,
              title: Text(
                'Chats',
                style: const TextStyle(
                  color: Color(0xFF0F1828),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                // Handle chats tap
                Get.to(Home2());
              },
            ),
            MenuItem(
              icon: Icons.brightness_3_rounded,
              title: Container(
                child: Text(
                  'Appearance ${_isLightTheme ? 'Light' : 'Dark'} theme',
                  style: const TextStyle(
                    color: Color(0xFF0F1828),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              onTap: () {
                // Handle appearance tap
                setState(() {
                  _isLightTheme = !_isLightTheme;
                });
              },
            ),
            MenuItem(
              icon: Icons.notifications,
              title: Text(
                'Notification',
                style: const TextStyle(
                  color: Color(0xFF0F1828),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                // Handle notification tap
              },
            ),
            MenuItem(
              icon: Icons.privacy_tip,
              title: Text(
                'Privacy',
                style: const TextStyle(
                  color: Color(0xFF0F1828),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                // Handle privacy tap
              },
            ),
            const Divider(),
            MenuItem(
              icon: Icons.help,
              title: Text(
                'Help',
                style: const TextStyle(
                  color: Color(0xFF0F1828),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                // Handle help tap
              },
            ),
            MenuItem(
              icon: Icons.mail,
              title: Text(
                'Invite Your Friends',
                style: const TextStyle(
                  color: Color(0xFF0F1828),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              onTap: () async {
                // Handle invite tap
                final result =
                    await Share.shareWithResult('https://zeva.com');

                if (result.status == ShareResultStatus.success) {
                  print('Thank you for sharing my website!');
                }
              },
            ),
            const Divider(),
            MenuItem(
              icon: Icons.logout_rounded,
              title: Text(
                'Logout',
                style: const TextStyle(
                  color: Color(0xFF0F1828),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                // Handle invite tap
                Get.dialog(AlertDialog(
                  icon: Icon(Icons.logout),
                  title: Text('Are you sure to logout?'),
                  actions: [
                    MaterialButton(
                      onPressed: () async {
                        await APIs.updateActiveStatus(false);
                        await APIs.auth.signOut().then((value) async {
                          await GoogleSignIn().signOut().then((value) {
                            // to hide progress bar
                            Navigator.pop(context);

                            APIs.auth = FirebaseAuth.instance;

                            // to move to previous page which is home screen
                            Get.back();
                           Get.off(Splash2());
                          });
                        });
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 104, 63, 181)),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'No',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 63, 181, 98)),
                      ),
                    ),
                  ],
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEDEDED), width: 1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFEDEDED),
            child: Icon(Icons.person, size: 30, color: Colors.grey[400]),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Rony Ahmed',
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '+62 1309 - 1710 - 1920',
                style: TextStyle(
                  color: Color(0xFFADB5BD),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final VoidCallback onTap;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[400], size: 24),
            const SizedBox(width: 16),
            Expanded(child: title),
            const Icon(Icons.chevron_right, color: Color(0xFF989898)),
          ],
        ),
      ),
    );
  }
}
