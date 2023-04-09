import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screen/address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  List name;
  List price;
  List image;

  CheckoutScreen({
    Key? key,
    required this.name,
    required this.image,
    required this.price,
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

  int newQuantity = 1;

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

    return Scaffold(
      appBar: appbar,
      body: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Delivery Address',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ),
            ),
            !city.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Card(
                      color: const Color(0xFFF5F6F9),
                      child: ListTile(
                        title: Text(city),
                        subtitle: Text(phone),
                        trailing: IconButton(
                          onPressed: () async {
                            String refresh = await Navigator.of(context)
                                .push(MaterialPageRoute(builder: (builder) {
                              return AddressScreen();
                            }));
                            if (refresh == 'omar') {
                              getData();
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(screenWidth * 0.8, screenHeight * 0.1),
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:
                              const Color.fromRGBO(246, 121, 82, 1),
                        ),
                        onPressed: () async {
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
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('admin_cart')
                      .snapshots(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6F9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.all(10),
                          height: 70,
                          child: ListTile(
                            title: Text(widget.name[index]),
                            leading: Image.network(widget.image[index]),
                            trailing: Container(
                              width: 109,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (newQuantity > 0) {
                                          setState(() {
                                            newQuantity--;
                                          });
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                      )),
                                  Text(newQuantity.toString()),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          newQuantity++;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: widget.name.length,
                    );
                  },
                )),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.8, screenHeight * 0.05),
                    backgroundColor: Color.fromRGBO(246, 121, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
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
                          'quantity': newQuantity,
                          'subtotal': '${element['price'] * newQuantity}',
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
                  child: const Text('Checkout'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
