import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screen/account_information_screen.dart';
import 'package:e_commerce/screen/addresses.dart';
import 'package:e_commerce/widgets/personal_items.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/theme_provider.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ModelTheme>(context, listen: false);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
                width: double.infinity,
                height: height * 0.2,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6F9),
                ),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  snapshot.data?.docs[0]['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                subtitle: Text(snapshot.data?.docs[0]['phone']),
                                trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return AccountInformationScreen();
                                      }));
                                    }),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return Addresses();
                                  }));
                                },
                                label: const Text(
                                  'Addresses',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    })),
          ),
          PersonalItems(iconData: Icons.settings, name: 'Settings'),
          PersonalItems(
              iconData: FontAwesomeIcons.cartArrowDown, name: 'My Orders'),
          PersonalItems(iconData: Icons.person_pin_rounded, name: 'About Us'),
          PersonalItems(iconData: Icons.logout, name: 'Sign Out')
        ],
      ),
    );
  }
}
