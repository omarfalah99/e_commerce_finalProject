import 'package:e_commerce/screen/favorite_screen.dart';
import 'package:e_commerce/screen/personal_information_screen.dart';
import 'package:e_commerce/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
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
    PersonalScreen(),
  ];

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: const Color.fromRGBO(246, 121, 82, 1),
      controller: _advancedDrawerController,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      openRatio: 0.70,
      rtlOpening: false,
      openScale: 0.90,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: Container(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
          leading: IconButton(
            onPressed: () {
              _advancedDrawerController.showDrawer();
            },
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
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
      ),
    );
  }
}
