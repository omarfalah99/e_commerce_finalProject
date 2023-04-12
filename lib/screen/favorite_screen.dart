import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('fav')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (context, index) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(246, 121, 82, 1),
                  ),
                );
              } else {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    color: Colors.red,
                    child: const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  onDismissed: (value) {
                    FirebaseFirestore.instance
                        .collection('fav')
                        .doc(FirebaseAuth.instance.currentUser?.email)
                        .collection('items')
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                  },
                  key: Key(snapshot.data!.docs[index].id),
                  child: ListTile(
                    title: Text(snapshot.data?.docs[index]['name']),
                    leading: Image.network(
                      snapshot.data?.docs[index]['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
            itemCount: snapshot.data?.docs.length,
          );
        },
      ),
    );
  }
}
