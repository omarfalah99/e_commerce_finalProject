import 'package:e_commerce/screen/main_screen.dart';
import 'package:e_commerce/screen/onboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/firebase_auth.dart';
import 'model/firestore_auth.dart';
import 'model/product_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider()),
      ChangeNotifierProvider<FirebaseAuthMethods>(
          create: (context) => FirebaseAuthMethods()),
      ChangeNotifierProvider(create: (context) => FirestoreData())
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gordita',
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0x44000000),
        ),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(246, 121, 82, 1),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return MainScreen();
            } else {
              return OnboardScreen();
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error Occured'),
            );
          }
          return Text('');
        },
      ),
    );
  }
}
