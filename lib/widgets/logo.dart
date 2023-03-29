import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  String image;
  String name;

  Logo({Key? key, required this.image, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        width: 70,
        height: 70,
        child: Center(
          child: Image.asset(
            image,
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
  }
}
