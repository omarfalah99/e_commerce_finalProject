import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../model/theme_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isItems = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ModelTheme>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_cart')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    'assets/empty_cart.svg',
                    height: height * 0.5,
                    width: double.infinity,
                  ),
                ),
                const Text(
                  'Your cart is empty.\nPlease add a few items',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              Expanded(
                flex: 8,
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      final data = snapshot.data?.docs[index];
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: const Align(
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
                            primary: const Color.fromRGBO(246, 121, 82, 1),
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
                              style: TextStyle(
                                color:
                                    !theme.isDark ? Colors.black : Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            leading: Image.network(data['imageUrl']),
                          ),
                        ),
                      );
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
