import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  String value;
  IconData iconData;

  InfoCard({Key? key, required this.iconData, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: const Color.fromRGBO(246, 121, 82, 1),
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: () {
          if (value == 'Sign Out') {
            FirebaseAuth.instance.signOut();
          }
        },
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(width: 20),
            Expanded(
                child: Text(
              value,
              style: TextStyle(color: Colors.black),
            )),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
