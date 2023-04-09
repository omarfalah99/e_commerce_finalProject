import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'description_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = "";
  String category = "";
  bool isCat = false;
  bool isDog = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                maxLengthEnforcement: MaxLengthEnforcement.none,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromRGBO(246, 121, 82, 1),
                  ),
                  hintText: 'Search...',
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(246, 121, 82, 1)),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          category = "Cat";
                        });
                        if (isCat) {
                          setState(() {
                            category = "";
                          });
                        }
                        setState(() {
                          isCat = !isCat;
                        });
                        if (isDog) {
                          setState(() {
                            isDog = false;
                          });
                        }
                      },
                      child: Container(
                        color: isCat
                            ? Color.fromRGBO(246, 121, 82, 1)
                            : Colors.transparent,
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          FontAwesomeIcons.cat,
                          color: isCat ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          category = "Dog";
                        });
                        if (isDog) {
                          setState(() {
                            category = "";
                          });
                        }
                        setState(() {
                          isDog = !isDog;
                        });
                        if (isCat) {
                          setState(() {
                            isCat = false;
                          });
                        }
                      },
                      child: Container(
                        color: isDog
                            ? const Color.fromRGBO(246, 121, 82, 1)
                            : Colors.transparent,
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          FontAwesomeIcons.dog,
                          color: isDog ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
              flex: 7,
              child: StreamBuilder<QuerySnapshot>(
                stream: category.isNotEmpty
                    ? FirebaseFirestore.instance
                        .collection('products')
                        .where('category', isEqualTo: category)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : (!name.isEmpty)
                          ? ListView.builder(
                              itemCount: snapshots.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshots.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                if (data['name']
                                    .toString()
                                    .toLowerCase()
                                    .contains(name.toLowerCase())) {
                                  return TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Color.fromRGBO(246, 121, 82, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return DescriptionScreen(
                                            image: data['imageUrl'],
                                            tag: 'tag',
                                            des: data['des'],
                                            name: data['name'],
                                            price: data['price']);
                                      }));
                                    },
                                    child: ListTile(
                                      title: Text(
                                        data['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      leading: Image.network(data['imageUrl']),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            )
                          : GridView.builder(
                              itemCount: snapshots.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshots.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                final products = snapshots.data!.docs[index];

                                if (name.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: const Color.fromRGBO(
                                            246, 121, 82, 1),
                                        padding: const EdgeInsets.all(20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        backgroundColor:
                                            const Color(0xFFF5F6F9),
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
                                            tag: 'wow$index',
                                            child: Image.network(
                                              products!['imageUrl'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Text(
                                            products['name'],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3,
                                mainAxisExtent: 275,
                              ),
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
