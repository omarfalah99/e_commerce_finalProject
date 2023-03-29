import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/logo.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController name = TextEditingController();

  Future<void> registerOrSignin() async {
    if (signOrLog) {
      try {
        final result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        FirebaseFirestore.instance
            .collection('users')
            .doc(result.user?.uid)
            .set({
          'name': name.text,
          'email': emailController.text,
          'password': passwordController.text,
          'id': result.user?.uid,
        });
        setState(() {
          signOrLog = !signOrLog;
        });
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
              titleTextStyle: TextStyle(color: Colors.deepOrange, fontSize: 18),
              content: Text('Email is incorrect'),
            );
          },
        );
      }
      emailController.text = '';
      passwordController.text = '';
      name.text = '';
      FocusScope.of(context).dispose();
    } else {
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
              titleTextStyle: TextStyle(color: Colors.deepOrange, fontSize: 18),
              content:
                  Text('Email and password are incorrect or user not created'),
            );
          },
        );
      }
    }
  }

  bool signOrLog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/Vector.png',
                height: 55,
                width: 54,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Log In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              signOrLog
                  ? Container(
                      width: double.infinity,
                      height: 57,
                      margin: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            margin: EdgeInsets.all(5),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(246, 121, 82, 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.person,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: name,
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.start,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(246, 121, 82, 1)),
                                ),
                                label: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(''),
              Container(
                width: double.infinity,
                height: 57,
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      margin: const EdgeInsets.all(5),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(246, 121, 82, 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/img.png'),
                    ),
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),
                          label: Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 57,
                margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      margin: EdgeInsets.all(5),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 121, 82, 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.lock,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.name,
                        obscureText: true,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),
                          label: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: signOrLog ? 19 : 275,
                  ),
                  // Checkbox()
                  Text(
                    signOrLog
                        ? 'I accept all the Terms & Conditions'
                        : 'Forgot password?',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
              ),
              GestureDetector(
                onTap: registerOrSignin,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 121, 82, 1),
                    borderRadius: BorderRadius.circular(133),
                  ),
                  width: 205,
                  height: 59,
                  child: Center(
                    child: Text(
                      !signOrLog ? 'Log in' : 'Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: !signOrLog ? 50 : 25,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                  ),
                  Container(
                    color: Colors.black,
                    height: 1,
                    width: 90,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Or'),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    color: Colors.black,
                    height: 1,
                    width: 90,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Logo(image: 'assets/Facebook.png', name: 'facebook'),
                  Logo(image: 'assets/googles.png', name: 'google'),
                ],
              ),
              SizedBox(
                height: !signOrLog ? 30 : 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    signOrLog
                        ? 'Already have an account?'
                        : 'Don\'t have an account?',
                    style: TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: Text(signOrLog ? 'Log In' : 'Sign Up',
                        style: TextStyle(
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: () {
                      setState(() {
                        signOrLog = !signOrLog;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
