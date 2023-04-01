import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/widgets/information_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                      radius: 50,
                      // Set background color of avatar
                      child: Center(
                        child: Text(
                          snapshot.data?.docs[0]['name'][0],
                          // Replace 'A' with the letter you want to display
                          style: TextStyle(
                            color: Colors.white, // Set text color
                            fontSize: 50, // Set font size
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.07,
                    ),
                    InfoCard(
                      iconData: Icons.person,
                      value: snapshot.data?.docs[0]['name'],
                    ),
                    InfoCard(
                      iconData: Icons.email,
                      value: snapshot.data?.docs[0]['email'],
                    ),
                    InfoCard(
                      iconData: Icons.password,
                      value: snapshot.data?.docs[0]['password'],
                    ),
                    InfoCard(
                      iconData: Icons.logout,
                      value: 'Sign Out',
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
