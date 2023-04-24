import 'package:e_commerce/screen/account_information_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/theme_provider.dart';
import 'login_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ModelTheme>(context, listen: false);
    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Common',
              style: TextStyle(
                color: Color.fromRGBO(246, 121, 82, 1),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Language'),
              subtitle: Text('English'),
              leading: Icon(Icons.language),
            ),
          ),
          SwitchListTile(
              activeColor: const Color.fromRGBO(246, 121, 82, 1),
              title: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              value: themeNotifier.isDark,
              onChanged: (val) {
                themeNotifier.isDark
                    ? themeNotifier.isDark = false
                    : themeNotifier.isDark = true;
              }),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Platform'),
              subtitle: Text('Default'),
              leading: Icon(Icons.mobile_friendly),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Account',
              style: TextStyle(
                color: Color.fromRGBO(246, 121, 82, 1),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) {
                  return const AccountInformationScreen();
                }));
              },
              title: Text('Account Information'),
              leading: Icon(Icons.person),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
              title: Text('Sign Out'),
              leading: Icon(Icons.logout),
            ),
          )
        ],
      ),
    );
  }
}
