import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screen/description_screen.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: snapshot.data?.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 275,
                  ),
                  itemBuilder: (context, index) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final products = snapshot.data?.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            primary: const Color.fromRGBO(246, 121, 82, 1),
                            padding: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: const Color(0xFFF5F6F9),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (c) {
                                  return DescriptionScreen(
                                    image: products['imageUrl'],
                                    tag: index.toString(),
                                    des: products['des'],
                                    name: products['name'],
                                    price: products['price'],
                                  );
                                },
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Hero(
                                tag: 'wow' + index.toString(),
                                child: Image.network(
                                  products!['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(products['name']),
                            ],
                          ),
                        ),
                      );
                    }
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
