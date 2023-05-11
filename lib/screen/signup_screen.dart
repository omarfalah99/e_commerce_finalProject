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

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Form(
        key: formkey,
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: name,
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Name is empty';
                      }
                    },
                    textInputAction: TextInputAction.next,
                    cursorColor: const Color.fromRGBO(246, 121, 82, 1),
                    decoration: const InputDecoration(
                      hintText: "Name",
                      prefixIcon: Icon(Icons.person,
                          color: Color.fromRGBO(246, 121, 82, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Email is empty';
                      } else if (!val.contains('@')) {
                        return 'Email should\'ve @ symbol';
                      } else if (val.length < 6) {
                        return 'Email is to short';
                      } else if (!val.endsWith('.com')) {
                        return 'Email is invalid';
                      }
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    cursorColor: const Color.fromRGBO(246, 121, 82, 1),
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email,
                          color: Color.fromRGBO(246, 121, 82, 1)),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: TextFormField(
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Password is empty';
                      } else if (val.length < 6) {
                        return 'Password is to short';
                      }
                    },
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    cursorColor: const Color.fromRGBO(246, 121, 82, 1),
                    decoration: const InputDecoration(
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
                  child: TextFormField(
                    controller: phone,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Phone is empty';
                      }
                    },
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    cursorColor: const Color.fromRGBO(246, 121, 82, 1),
                    decoration: const InputDecoration(
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
                    final state = formkey.currentState;
                    if (state!.validate()) {
                      print('valid');
                    }
                    try {
                      final result = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(result.user?.uid)
                          .set({
                        'name': name.text,
                        'email': emailController.text,
                        'password': passwordController.text,
                        'phone': phone.text,
                        'id': result.user?.uid,
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }),
                        (route) => false,
                      );
                    } catch (e) {}
                    // FocusScope.of(context).dispose();
                  },
                  child: const Text('Sign Up'),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                          return LoginPage();
                        }));
                      },
                      child: const Text(
                        "Log in",
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
