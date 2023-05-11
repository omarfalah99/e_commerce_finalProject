import 'package:e_commerce/screen/about_us.dart';
import 'package:e_commerce/screen/my_orders_screen.dart';
import 'package:e_commerce/screen/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/theme_provider.dart';
import '../screen/welcome_screen.dart';

class PersonalItems extends StatelessWidget {
  String name;
  IconData iconData;

  PersonalItems({
    Key? key,
    required this.iconData,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ModelTheme>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: const Color.fromRGBO(246, 121, 82, 1),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor:
              themeNotifier.isDark ? Colors.black : const Color(0xFFF5F6F9),
        ),
        onPressed: () {
          if (name == 'Settings') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return SettingsScreen();
            }));
          }
          if (name == 'My Orders') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MyOrders();
            }));
          }
          if (name == 'About Us') {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AboutUsPage();
            }));
          }
          if (name == 'Sign Out') {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          }
        },
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(width: 20),
            Expanded(
                child: Text(
              name,
              style: TextStyle(color: Colors.black, fontSize: 15),
            )),
          ],
        ),
      ),
    );
  }
}
