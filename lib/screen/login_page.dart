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
  var email = '';
  var password = '';
  final form = GlobalKey<FormState>();

  void login() async {
    final formstate = form.currentState;
    if (formstate!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (builder) {
          return MainScreen();
        }));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('User not found'),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(246, 121, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        } else if (e.code == 'wrong-password') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Password is incorrect'),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(246, 121, 82, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        } else {
          print('Something went wrong: ${e.message}');
        }
      }
    }
    // if (formstate!.validate()) {
    //   print('valid');
    // }
    // try {
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //     return MainScreen();
    //   }));
    // } on FirebaseAuthException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Form(
        key: form,
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Email is empty';
                      } else if (!val.contains('@')) {
                        return 'Email should\'ve @ symbol';
                      } else if (val.length < 6) {
                        return 'Email is to short';
                      }
                    },
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
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Password is empty';
                      } else if (val.length < 6) {
                        return 'Password is to short';
                      }
                    },
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
                  onPressed: login,
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
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) {
                              return const SignUpScreen();
                            },
                          ),
                          (route) => false,
                        );
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
      ),
    );
  }
}
