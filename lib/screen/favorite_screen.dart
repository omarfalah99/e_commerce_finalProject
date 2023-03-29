import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(246, 121, 82, 1),
          ),
        ),
      ),
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
                return Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(246, 121, 82, 1),
                  ),
                );
              } else {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Align(
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                        alignment: Alignment.centerRight),
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
