import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
      leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_rounded,
          )),
    );

    final screenHeight =
        MediaQuery.of(context).size.height - appbar.preferredSize.height;

    return Scaffold(
      appBar: appbar,
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   return MyApp();
                // }));
              },
              child: Text('Click'),
            )
          ],
        ),
      ),
    );
  }
}
