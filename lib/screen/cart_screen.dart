import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isItems = false;

  int ari = 0;

  void data() async {
    final wow =
        await FirebaseFirestore.instance.collection('user_cart').count().get();
    print(wow.count);
    setState(() {
      ari = wow.count;
    });
  }

  @override
  void initState() {
    data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_cart')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          return Column(
            children: [
              ari == 0
                  ? const Center(
                      child: Text('There are no items in the cart'),
                    )
                  : Expanded(
                      flex: 8,
                      child: ListView.builder(
                          itemBuilder: (context, index) {
                            final data = snapshot.data?.docs[index];
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                    color: Colors.red,
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                                key: UniqueKey(),
                                onDismissed: (val) {
                                  FirebaseFirestore.instance
                                      .collection('user_cart')
                                      .doc(snapshot.data?.docs[index].id)
                                      .delete();
                                },
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Color.fromRGBO(246, 121, 82, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  onPressed: () {},
                                  child: ListTile(
                                    title: Text(
                                      data!['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    leading: Image.network(data['imageUrl']),
                                  ),
                                ),
                              );
                            }
                          },
                          itemCount: snapshot.data?.docs.length),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Go To Checkout'),
                  onPressed: () async {
                    final data = await FirebaseFirestore.instance
                        .collection('user_cart')
                        .where('email',
                            isEqualTo: FirebaseAuth.instance.currentUser?.email
                                .toString())
                        .get();
                    List price = [];
                    List<String> name = [];
                    List quantity = [];
                    List<String> image = [];
                    List subtotal = [];

                    data.docs.forEach((element) {
                      price.add(element['price']);
                      name.add(element['name']);
                      quantity.add(element['quantity']);
                      image.add(element['imageUrl']);
                      subtotal.add(element['subtotal']);
                    });

                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return CheckoutScreen(
                        name: name,
                        image: image,
                        price: price,
                        quantity: quantity,
                        subtotal: subtotal,
                      );
                    }));
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
