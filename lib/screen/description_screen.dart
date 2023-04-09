import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DescriptionScreen extends StatefulWidget {
  String tag;
  String des;
  String name;
  String image;
  int price;

  DescriptionScreen(
      {Key? key,
      required this.image,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(246, 121, 82, 1),
        elevation: 0,
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
                Text(
                  widget.des,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    '${widget.price * quantity} \$',
                    style:
                        const TextStyle(color: Color.fromRGBO(246, 121, 82, 1)),
                  ),
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
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .collection('carts')
                          .add({
                        'name': widget.name,
                        'imageUrl': widget.image,
                        'quantity': quantity,
                        'price': widget.price,
                      });
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Item added to cart'),
                            );
                          });
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
