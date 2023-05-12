import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screen/address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/theme_provider.dart';

class Addresses extends StatefulWidget {
  const Addresses({Key? key}) : super(key: key);

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ModelTheme>(context, listen: false);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('address')
                .where('email',
                    isEqualTo: FirebaseAuth.instance.currentUser?.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, screenHeight * 0.07),
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (builder) {
                        return AddressScreen();
                      }));
                    },
                    child: const Text('Add Address'),
                  ),
                );
              }
              return Card(
                color: themeNotifier.isDark
                    ? Colors.black
                    : const Color(0xFFF5F6F9),
                child: ListTile(
                  title: Text(snapshot.data!.docs[0]['city']),
                  subtitle: Text(snapshot.data!.docs[0]['phone']),
                  trailing: IconButton(
                    onPressed: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (builder) {
                        return AddressScreen();
                      }));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
