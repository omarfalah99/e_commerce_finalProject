import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/drawer_items.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('id',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  } else {
                    return DrawerHeader(
                      child: Text(
                        'Welcome ' + snapshot.data?.docs[0]['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                }),
            DrawerItems(title: 'My favorites', iconData: Icons.favorite),
            DrawerItems(
                title: 'My orders', iconData: Icons.shopping_bag_rounded),
            DrawerItems(title: 'About us', iconData: Icons.info_rounded),
            DrawerItems(title: 'Privacy policy', iconData: Icons.lock),
            DrawerItems(title: 'Settings', iconData: Icons.settings),
          ],
        ),
      ),
    );
  }
}
