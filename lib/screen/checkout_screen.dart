import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/theme_provider.dart';
import 'address_screen.dart';

class CheckoutScreen extends StatefulWidget {
  List<String> name;
  List price;
  List<String> image;
  List quantity;
  List subtotal;

  CheckoutScreen({
    Key? key,
    required this.quantity,
    required this.name,
    required this.image,
    required this.price,
    required this.subtotal,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String city = '';
  String garak = '';
  String street = '';
  String phone = '';

  Future<void> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      city = sharedPreferences.getString('city')!;
      garak = sharedPreferences.getString('garak')!;
      street = sharedPreferences.getString('street')!;
      phone = sharedPreferences.getString('phone')!;
    });
  }

  bool haveAddess = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
      backgroundColor: Color.fromRGBO(246, 121, 82, 1),
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          )),
    );

    final screenHeight =
        MediaQuery.of(context).size.height - appbar.preferredSize.height;
    final screenWidth = MediaQuery.of(context).size.width;

    List list = [];
    final themeNotifier = Provider.of<ModelTheme>(context, listen: false);

    return Scaffold(
      appBar: appbar,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('address')
              .where('email',
                  isEqualTo: FirebaseAuth.instance.currentUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            // final address = snapshot.data?.docs[0];
            return Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Delivery Address',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                !(snapshot.data == null || snapshot.data!.docs.isEmpty)
                    ? Padding(
                        padding: const EdgeInsets.all(15),
                        child: Card(
                          color: themeNotifier.isDark
                              ? Colors.black
                              : const Color(0xFFF5F6F9),
                          child: ListTile(
                            title: Text(snapshot.data?.docs[0]!['city']),
                            subtitle: Text(snapshot.data?.docs[0]['phone']),
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(screenWidth * 0.8, screenHeight * 0.07),
                              padding: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor:
                                  const Color.fromRGBO(246, 121, 82, 1),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (builder) {
                                return AddressScreen();
                              }));
                            },
                            child: const Text('Add Address'),
                          ),
                        ),
                      ),
                Expanded(
                  flex: 8,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: themeNotifier.isDark
                              ? Colors.black
                              : const Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.all(10),
                        height: 70,
                        child: ListTile(
                          title: Text(widget.name[index]),
                          leading: Image.network(widget.image[index]),
                          subtitle: Text(widget.price[index] + ' \$'),
                          trailing: Text(widget.quantity[index].toString()),
                        ),
                      );
                    },
                    itemCount: widget.name.length,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: ListTile(
                      onTap: () {},
                      title: const Text('Total Price'),
                      trailing: widget.subtotal.isEmpty
                          ? const Text('No products added to cart')
                          : Text(
                              '${widget.subtotal.reduce((value, element) => value + element)} \$'),
                    )),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (snapshot.data == null ||
                            snapshot.data!.docs.isEmpty)
                        ? const Text(
                            'Please first add address to complete your order',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(screenWidth * 0.8, screenHeight * 0.05),
                              backgroundColor:
                                  const Color.fromRGBO(246, 121, 82, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () async {
                              final data = await FirebaseFirestore.instance
                                  .collection('user_cart')
                                  .where('email',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser?.email
                                          .toString())
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

                              data.docs.forEach((element) {
                                list.add({
                                  'name': element['name'],
                                  'price': element['price'],
                                  'quantity': element['quantity'],
                                  'subtotal': element['quantity'] *
                                      double.parse(element['price']),
                                  'imageUrl': element['imageUrl'],
                                });
                              });

                              data.docs.forEach(
                                (element) {
                                  FirebaseFirestore.instance
                                      .collection('admin_cart')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.email
                                          .toString())
                                      .set({
                                    'email': FirebaseAuth
                                        .instance.currentUser!.email,
                                    'items': FieldValue.arrayUnion(list),
                                    'nameOfUser': userName,
                                    'phone': phone,
                                    'date': DateTime.now().toString(),
                                    'city': snapshot.data?.docs[0]['city'],
                                    'garak': snapshot.data?.docs[0]['garak'],
                                    'orderNo': Random().nextInt(10000),
                                    'street': snapshot.data?.docs[0]['street'],
                                  });
                                },
                              );
                              final wow = await FirebaseFirestore.instance
                                  .collection('user_cart')
                                  .where('email',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser?.email
                                          .toString())
                                  .get();
                              wow.docs.forEach(
                                  (element) => {element.reference.delete()});
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Dear Customer'),
                                    content: Text(
                                        'We will contact you as soon as possible.'),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor:
                                              Color.fromRGBO(246, 121, 82, 1),
                                        ),
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              Navigator.of(context).pop();
                            },
                            child: const Text('Order'),
                          ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
