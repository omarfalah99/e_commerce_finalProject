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
    double width = MediaQuery.of(context).size.width;

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
                    mainAxisExtent: 265,
                  ),
                  itemBuilder: (context, index) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(246, 121, 82, 1),
                          strokeWidth: 3,
                        ),
                      );
                    } else {
                      final products = snapshot.data?.docs[index];
                      return InkWell(
                        onTap: () {
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
                        child: Container(
                          width: width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromRGBO(254, 252, 243, 1),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Hero(
                                tag: 'wow' + index.toString(),
                                child: Image.network(
                                  products!['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(products['name']),
                                ],
                              ),
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
