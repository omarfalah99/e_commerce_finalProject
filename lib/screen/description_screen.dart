import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DescriptionScreen extends StatefulWidget {
  String tag;
  String des;
  String name;
  String image;
  String kg;
  String price;
  String barcode;

  DescriptionScreen(
      {Key? key,
      required this.image,
      required this.kg,
      required this.barcode,
      required this.tag,
      required this.des,
      required this.name,
      required this.price})
      : super(key: key);

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  Future addToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("fav");
    return _collectionRef
        .doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget.name,
      "imageUrl": widget.image,
    }).then((value) => print("Added to favourite"));
  }

  int quantity = 1;

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    margin: EdgeInsets.all(20),
                    child: BarcodeWidget(
                      barcode: Barcode.code39(),
                      data: widget.barcode,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        color: Color.fromRGBO(246, 121, 82, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        '${widget.price} \$',
                        style: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                            print(quantity);
                          }
                        },
                        icon: const Icon(
                          Icons.remove,
                          color: Color.fromRGBO(246, 121, 82, 1),
                        )),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(
                        color: Color.fromRGBO(246, 121, 82, 1),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Color.fromRGBO(246, 121, 82, 1),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Text(
                    'Total price ${int.parse(widget.price) * quantity} \$',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(246, 121, 82, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 50)),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('user_cart')
                          .add({
                        'name': widget.name,
                        'imageUrl': widget.image,
                        'quantity': quantity,
                        'price': widget.price,
                        'subtotal': int.parse(widget.price) * quantity,
                        'email':
                            FirebaseAuth.instance.currentUser?.email.toString(),
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add to cart'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(246, 121, 82, 1),
        elevation: 0,
        title: Text(widget.name),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('fav')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('items')
              .where('name', isEqualTo: widget.name)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'wow${widget.tag}',
                      child: Image.network(
                        widget.image,
                        height: 300,
                        width: double.infinity,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () => snapshot.data?.docs.length == 0
                              ? addToFavourite()
                              : showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: Text('Already added to fav'),
                                    );
                                  }),
                          icon: snapshot.data?.docs.length == 0
                              ? const Icon(
                                  Icons.favorite_outline,
                                  color: Color.fromRGBO(246, 121, 82, 1),
                                )
                              : const Icon(
                                  Icons.favorite,
                                  color: Color.fromRGBO(246, 121, 82, 1),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.des,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Text(
                  widget.kg + ' kg',
                  style: TextStyle(
                    color: Color.fromRGBO(246, 121, 82, 1),
                  ),
                )),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 50)),
                    onPressed: () async {
                      _showBottomSheet(context);
                    },
                    child: const Text('Add to cart'),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
