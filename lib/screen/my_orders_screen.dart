import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/theme_provider.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ModelTheme>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('myOrders')
            .where('email',
                isEqualTo: FirebaseAuth.instance.currentUser?.email.toString())
            .snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final data = snapshot.data?.docs[index];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return TextButton(
                  style: TextButton.styleFrom(
                    primary: const Color.fromRGBO(246, 121, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {},
                  child: ListTile(
                    subtitle: Text(data!['date'].toString().substring(0, 16)),
                    title: Text(
                      data['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            !themeNotifier.isDark ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Text(data!['quantity'].toString()),
                    leading: Image.network(data['imageUrl']),
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
