import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              Expanded(
                flex: 12,
                child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(246, 121, 82, 1),
                          strokeWidth: 3,
                        ),
                      );
                    } else {
                      final cart = snapshot.data?.docs[index];
                      return Container(
                        margin: const EdgeInsets.all(10),
                        height: 70,
                        color: const Color.fromRGBO(254, 252, 243, 1),
                        child: ListTile(
                          title: Text(cart!['name']),
                          leading: Image.network(cart['imageUrl']),
                          subtitle:
                              Text('${cart['price'] * cart['quantity']} \$'),
                          trailing: Text('${cart['quantity']}'),
                        ),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(double.infinity, 20),
                    ),
                    child: const Text('Go To Checkout'),
                    onPressed: () async {
                      final data = await FirebaseFirestore.instance
                          .collection('user_cart')
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection('carts')
                          .get();

                      String userName = '';
                      String phone = '';

                      final data2 = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .get()
                          .then((value) {
                        userName = value['name'];
                        phone = value['phone'];
                      });

                      data.docs.forEach(
                        (element) {
                          FirebaseFirestore.instance
                              .collection('admin_cart')
                              .add({
                            'name': element['name'],
                            'imageUrl': element['imageUrl'],
                            'email': FirebaseAuth.instance.currentUser!.email,
                            'price': element['price'],
                            'quantity': element['quantity'],
                            'subtotal':
                                '${element['price'] * element['quantity']}',
                            'nameOfUser': userName,
                            'phone': phone
                          });
                          FirebaseFirestore.instance
                              .collection('user_cart')
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection('carts')
                              .doc(element.id)
                              .delete();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
