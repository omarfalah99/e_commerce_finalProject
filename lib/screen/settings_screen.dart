import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/theme_provider.dart';

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
      appBar: AppBar(),
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
        ],
      ),
    );
  }
}
