import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final stream = FirebaseFirestore.instance
      .collection('user_cart')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('carts')
      .snapshots();

  bool isItems = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: const Text('Go To Checkout'),
                  onPressed: () async {
                    // final cart = snapshot.data?.docs[index];
                    final data = await FirebaseFirestore.instance
                        .collection('user_cart')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('carts')
                        .get();

                    List name = [];
                    List image = [];
                    List price = [];
                    List quantity = [];

                    data.docs.forEach((element) {
                      name.add(element['name']);
                      image.add(element['imageUrl']);
                      price.add(element['price']);
                      quantity.add(element['quantity']);
                    });
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return CheckoutScreen(
                        name: name,
                        image: image,
                        price: price,
                      );
                    }));
                    // final data = await FirebaseFirestore.instance
                    //     .collection('user_cart')
                    //     .doc(FirebaseAuth.instance.currentUser!.email)
                    //     .collection('carts')
                    //     .get();
                    //
                    // String userName = '';
                    // String phone = '';
                    //
                    // final data2 = await FirebaseFirestore.instance
                    //     .collection('users')
                    //     .doc(FirebaseAuth.instance.currentUser?.uid)
                    //     .get()
                    //     .then((value) {
                    //   userName = value['name'];
                    //   phone = value['phone'];
                    // });
                    //
                    // data.docs.forEach(
                    //   (element) {
                    //     FirebaseFirestore.instance
                    //         .collection('admin_cart')
                    //         .add({
                    //       'name': element['name'],
                    //       'imageUrl': element['imageUrl'],
                    //       'email': FirebaseAuth.instance.currentUser!.email,
                    //       'price': element['price'],
                    //       'quantity': element['quantity'],
                    //       'subtotal':
                    //           '${element['price'] * element['quantity']}',
                    //       'nameOfUser': userName,
                    //       'phone': phone
                    //     });
                    //     FirebaseFirestore.instance
                    //         .collection('user_cart')
                    //         .doc(FirebaseAuth.instance.currentUser!.email)
                    //         .collection('carts')
                    //         .doc(element.id)
                    //         .delete();
                    //   },
                    // );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
