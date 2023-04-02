import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screen/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              Image.asset(
                'assets/6333050.jpg',
                height: height * 0.3,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: name,
                  textInputAction: TextInputAction.next,
                  cursorColor: Color.fromRGBO(246, 121, 82, 1),
                  decoration: InputDecoration(
                    hintText: "Name",
                    prefixIcon: Icon(Icons.person,
                        color: Color.fromRGBO(246, 121, 82, 1)),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: Color.fromRGBO(246, 121, 82, 1),
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email,
                        color: Color.fromRGBO(246, 121, 82, 1)),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  cursorColor: Color.fromRGBO(246, 121, 82, 1),
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(
                      Icons.password,
                      color: Color.fromRGBO(246, 121, 82, 1),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  cursorColor: Color.fromRGBO(246, 121, 82, 1),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color.fromRGBO(246, 121, 82, 1),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(width * 0.8, height * 0.07)),
                onPressed: () async {
                  try {
                    final result = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(result.user?.uid)
                        .set({
                      'name': name.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                      'phone': phone.text,
                      'id': result.user?.uid,
                    });
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Acc Created'),
                          );
                        });
                    FocusScope.of(context).dispose();
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          titleTextStyle:
                              TextStyle(color: Colors.deepOrange, fontSize: 18),
                          content: Text('Email is incorrect'),
                        );
                      },
                    );
                  }
                  emailController.text = '';
                  passwordController.text = '';
                  name.text = '';
                  phone.text = '';
                  FocusScope.of(context).dispose();
                },
                child: const Text('Sign Up'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don’t have an Account ? ",
                    style:
                        const TextStyle(color: Color.fromRGBO(246, 121, 82, 1)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                    },
                    child: Text(
                      "Log in",
                      style: const TextStyle(
                        color: Color.fromRGBO(246, 121, 82, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
