import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/about_us_photo.jpg',
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'Areous Veterinary Clinic',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            const Text(
              'An e-commerce app for selling animal foods is a mobile application designed to facilitate the buying and selling of animal food products through digital means. The app allows users to browse a wide range of animal food products, including but not limited to, cat food, dog food.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact us:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.email),
                SizedBox(width: 8),
                Text('omarfalah@gmail.com'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.phone),
                SizedBox(width: 8),
                Text('+964 751 050 3515'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
