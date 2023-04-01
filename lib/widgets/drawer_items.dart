import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screen/favorite_screen.dart';

class DrawerItems extends StatelessWidget {
  String title;
  IconData iconData;

  DrawerItems({Key? key, required this.title, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
        primary: const Color.fromRGBO(246, 121, 82, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Color(0xFFF5F6F9),
      ),
      onPressed: () {
        if (title == 'Log out') {
          FirebaseAuth.instance.signOut();
        } else if (title == 'My favorites') {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FavoriteScreen();
          }));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          leading: Icon(
            iconData,
            color: Color.fromRGBO(246, 121, 82, 1),
          ),
        ),
      ),
    );
  }
}
