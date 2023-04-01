import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'description_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  decoration: const InputDecoration(
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;

                              if (name.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: TextButton(
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
                                  ),
                                );
                              }
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
                            });
                  },
                ),
              ),
            ],
          )),
    );
  }
}
