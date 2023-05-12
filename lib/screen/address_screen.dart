import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  var street = TextEditingController();
  var city = TextEditingController();
  var garak = TextEditingController();
  var phone = TextEditingController();

  String dropdownValue = 'Home';

  final formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      title: Text('Add Address'),
      // leading: Container(),
    );
    final screenHeight =
        MediaQuery.of(context).size.height - appbar.preferredSize.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: formstate,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appbar,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'City is empty';
                  }
                },
                controller: city,
                decoration: const InputDecoration(hintText: 'City'),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(15),
              child: DropdownButton<String>(
                dropdownColor: const Color.fromRGBO(246, 121, 82, 1),
                borderRadius: BorderRadius.circular(15),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                ),
                value: dropdownValue,
                items: <String>['Home', 'Office']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    print(dropdownValue);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Garak is empty';
                  }
                },
                controller: garak,
                decoration: const InputDecoration(hintText: 'Garak'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Street is empty';
                  }
                },
                controller: street,
                decoration: const InputDecoration(hintText: 'Street name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Phone is empty';
                  }
                },
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Phone'),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  if (formstate.currentState!.validate()) {
                    await FirebaseFirestore.instance
                        .collection('address')
                        .doc(FirebaseAuth.instance.currentUser?.email)
                        .set({
                      'email':
                          FirebaseAuth.instance.currentUser?.email.toString(),
                      'city': city.text,
                      'street': street.text,
                      'phone': phone.text,
                      'garak': garak.text,
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Save Address'))
          ],
        ),
      ),
    );
  }
}
