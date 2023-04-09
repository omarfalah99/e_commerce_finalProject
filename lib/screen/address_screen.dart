import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
          )),
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
                decoration: InputDecoration(hintText: 'City'),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(15),
              child: DropdownButton<String>(
                dropdownColor: Color.fromRGBO(246, 121, 82, 1),
                borderRadius: BorderRadius.circular(15),
                icon: Icon(
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
                decoration: InputDecoration(hintText: 'Garak'),
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
                decoration: InputDecoration(hintText: 'Street name'),
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
                decoration: InputDecoration(hintText: 'Phone'),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(246, 121, 82, 1),
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  if (formstate.currentState!.validate()) {
                    SharedPreferences address =
                        await SharedPreferences.getInstance();
                    address.setString('city', city.text);
                    address.setString('garak', garak.text);
                    address.setString('street', street.text);
                    address.setString('phone', phone.text);
                    Navigator.of(context).pop('omar');
                  }
                },
                child: const Text('Save Address'))
          ],
        ),
      ),
    );
  }
}
