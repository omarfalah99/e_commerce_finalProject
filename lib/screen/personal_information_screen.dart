import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screen/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return SettingsScreen();
                          }));
                        },
                        child: Text('Settings')),

                    // SizedBox(
                    //   height: height * 0.05,
                    // ),
                    // InfoCard(
                    //   iconData: Icons.person,
                    //   value: snapshot.data?.docs[0]['name'],
                    // ),
                    // InfoCard(
                    //   iconData: Icons.email,
                    //   value: snapshot.data?.docs[0]['email'],
                    // ),
                    // InfoCard(
                    //   iconData: Icons.password,
                    //   value: snapshot.data?.docs[0]['password'],
                    // ),
                    // InfoCard(
                    //   iconData: Icons.phone,
                    //   value: snapshot.data?.docs[0]['phone'],
                    // ),
                    // InfoCard(
                    //   iconData: Icons.logout,
                    //   value: 'Sign Out',
                    // ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
