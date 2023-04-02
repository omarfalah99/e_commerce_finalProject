import 'package:e_commerce/screen/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPaeState();
}

class _LoginPaeState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                'assets/login.jpg',
                height: height * 0.4,
                width: width * 0.7,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: const Color.fromRGBO(246, 121, 82, 1),
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Image.asset('assets/img.png'),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: TextField(
                  textInputAction: TextInputAction.done,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  cursorColor: const Color.fromRGBO(246, 121, 82, 1),
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Image.asset('assets/img.png'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(246, 121, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: Size(width * 0.8, height * 0.07)),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(246, 121, 82, 1),
                          ),
                        );
                      });
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return MainScreen();
                    }));
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text('Wrong Credentials'),
                          titleTextStyle:
                              TextStyle(color: Colors.deepOrange, fontSize: 18),
                          content: Text(
                              'Email and password are incorrect or user not created'),
                        );
                      },
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Don’t have an Account ? ",
                    style: TextStyle(color: Color.fromRGBO(246, 121, 82, 1)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const SignUpScreen();
                      }));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
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
