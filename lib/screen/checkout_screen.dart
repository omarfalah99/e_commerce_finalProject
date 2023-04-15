import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screen/address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              child: ListView.builder(
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
                      ? Text('No products added to cart')
                      : Text(
                          '${widget.subtotal.reduce((value, element) => value + element)} \$'),
                )),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.8, screenHeight * 0.05),
                    backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    final data = await FirebaseFirestore.instance
                        .collection('user_cart')
                        .where('email',
                            isEqualTo: FirebaseAuth.instance.currentUser?.email
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
                        'subtotal':
                            element['quantity'] * int.parse(element['price']),
                      });
                    });

                    data.docs.forEach(
                      (element) {
                        FirebaseFirestore.instance
                            .collection('admin_cart')
                            .doc(FirebaseAuth.instance.currentUser?.email
                                .toString())
                            .set({
                          // 'name': element['name'],
                          'imageUrl': element['imageUrl'],
                          'email': FirebaseAuth.instance.currentUser!.email,
                          // 'price': element['price'],
                          // 'quantity': element['quantity'],
                          // 'subtotal':
                          //     element['quantity'] * int.parse(element['price']),
                          'items': FieldValue.arrayUnion(list),
                          'nameOfUser': userName,
                          'phone': phone,
                          'date': DateTime.now().toString(),
                          'city': city,
                          'garak': garak,
                        });
                      },
                    );
                    final wow = await FirebaseFirestore.instance
                        .collection('user_cart')
                        .where('email',
                            isEqualTo: FirebaseAuth.instance.currentUser?.email
                                .toString())
                        .get();
                    wow.docs.forEach((element) => {element.reference.delete()});
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
