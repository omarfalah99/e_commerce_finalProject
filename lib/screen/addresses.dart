import 'package:e_commerce/screen/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/theme_provider.dart';

class Addresses extends StatefulWidget {
  const Addresses({Key? key}) : super(key: key);

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  @override
  Widget build(BuildContext context) {
    String city = '';
    String garak = '';
    String street = '';
    String phone = '';

    Future<void> getData() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      setState(() {
        city = sharedPreferences.getString('city')!;
        garak = sharedPreferences.getString('garak')!;
        street = sharedPreferences.getString('street')!;
        phone = sharedPreferences.getString('phone')!;
      });
    }

    final themeNotifier = Provider.of<ModelTheme>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Card(
                  color: themeNotifier.isDark
                      ? Colors.black
                      : const Color(0xFFF5F6F9),
                  child: ListTile(
                    title: Text(snapshot.data!.getString('city').toString()),
                    subtitle:
                        Text(snapshot.data!.getString('phone').toString()),
                    trailing: IconButton(
                      onPressed: () async {
                        String refresh = await Navigator.of(context)
                            .push(MaterialPageRoute(builder: (builder) {
                          return AddressScreen();
                        }));
                        if (refresh == 'omar') {
                          getData();
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
