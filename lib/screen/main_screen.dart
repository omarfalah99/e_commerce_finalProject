import 'package:e_commerce/screen/favorite_screen.dart';
import 'package:e_commerce/screen/personal_information_screen.dart';
import 'package:e_commerce/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'cart_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final globalKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  static List<Widget> screenNames = <Widget>[
    SearchScreen(),
    CartScreen(),
    FavoriteScreen(),
    PersonalInformation(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 130,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                child: Image.asset(
                  'assets/about_us_photo.jpg',
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'Areous',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        // centerTitle: true,
      ),
      key: globalKey,
      body: screenNames.elementAt(selectedIndex),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: GNav(
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            gap: 8,
            backgroundColor: Colors.transparent,
            selectedIndex: selectedIndex,
            color: const Color.fromRGBO(246, 121, 82, 1),
            activeColor: const Color.fromRGBO(246, 121, 82, 1),
            tabBackgroundColor: const Color.fromRGBO(246, 121, 82, 0.4),
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
              ),
              GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
              GButton(
                icon: Icons.favorite_border_rounded,
                text: 'Favorite',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
