import 'package:e_commerce/screen/favorite_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  String title;
  IconData iconData;

  DrawerItems({Key? key, required this.title, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == 'Log out') {
          FirebaseAuth.instance.signOut();
        } else if (title == 'My favorites') {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FavoriteScreen();
          }));
        }
      },
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        leading: Container(
          width: 27,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color.fromRGBO(246, 121, 82, 0.1),
          ),
          child: Icon(
            iconData,
            color: Color.fromRGBO(246, 121, 82, 1),
          ),
        ),
      ),
    );
  }
}
