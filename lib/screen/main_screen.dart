import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screen/personal_information_screen.dart';
import 'package:e_commerce/screen/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../widgets/drawer_items.dart';
import 'cart_screen.dart';
import 'categories_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final globalKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  static List<Widget> screenNames = <Widget>[
    CategoriesScreen(),
    CartScreen(),
    SearchScreen(),
    PersonalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('');
                    } else {
                      return DrawerHeader(
                        child: Text(snapshot.data?.docs[0]['name']),
                      );
                    }
                  }),
              DrawerItems(title: 'My favorites', iconData: Icons.favorite),
              DrawerItems(iconData: Icons.wallet_outlined, title: 'Wallets'),
              DrawerItems(
                  title: 'My orders', iconData: Icons.shopping_bag_rounded),
              DrawerItems(title: 'About us', iconData: Icons.info_rounded),
              DrawerItems(title: 'Privacy policy', iconData: Icons.lock),
              DrawerItems(title: 'Settings', iconData: Icons.settings),
              SizedBox(
                height: 50,
              ),
              DrawerItems(title: 'Log out', iconData: Icons.logout),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.deepOrange,
          ),
          onPressed: () async {
            globalKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: screenNames.elementAt(selectedIndex),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: GNav(
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            gap: 8,
            backgroundColor: Colors.white,
            selectedIndex: selectedIndex,
            color: Color.fromRGBO(246, 121, 82, 1),
            activeColor: Color.fromRGBO(246, 121, 82, 1),
            tabBackgroundColor: Color.fromRGBO(246, 121, 82, 0.4),
            padding: EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.person_outline,
                text: 'Person',
              )
            ],
          ),
        ),
      ),
    );
  }
}
