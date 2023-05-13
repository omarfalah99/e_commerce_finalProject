import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({Key? key}) : super(key: key);

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  final updatedName = TextEditingController();
  final updatedEmail = TextEditingController();
  final oldPassword = TextEditingController();
  final updatedPhone = TextEditingController();
  final updatedPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final data = snapshot.data?.docs[0];
              return Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: const Color.fromRGBO(246, 121, 82, 1),
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              data!['name'],
                              style: const TextStyle(color: Colors.black),
                            )),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return SimpleDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        contentPadding: EdgeInsets.all(20),
                                        titlePadding: EdgeInsets.all(20),
                                        children: [
                                          TextField(
                                            decoration: const InputDecoration(
                                                hintText: 'Name'),
                                            controller: updatedName,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              String pass = '';
                                              String phone = '';

                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .get()
                                                  .then((value) {
                                                pass = value['password'];
                                                phone = value['phone'];
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .set({
                                                'email': FirebaseAuth.instance
                                                    .currentUser?.email,
                                                'id': FirebaseAuth
                                                    .instance.currentUser?.uid,
                                                'name': updatedName.text,
                                                'password': pass,
                                                'phone': phone,
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      246, 121, 82, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text('Update Name'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: const Color.fromRGBO(246, 121, 82, 1),
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            const Icon(Icons.password),
                            const SizedBox(width: 20),
                            const Expanded(
                                child: Text(
                              'Password',
                              style: TextStyle(color: Colors.black),
                            )),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return SimpleDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        titlePadding: const EdgeInsets.all(20),
                                        children: [
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                hintText: 'Old Password'),
                                            controller: oldPassword,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            decoration: const InputDecoration(
                                                hintText: 'New Password'),
                                            controller: updatedPassword,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              String phone = '';
                                              String name = '';

                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .get()
                                                  .then((value) {
                                                phone = value['phone'];
                                                name = value['name'];
                                              });
                                              var cred =
                                                  EmailAuthProvider.credential(
                                                      email: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .email
                                                          .toString(),
                                                      password:
                                                          oldPassword.text);

                                              try {
                                                await FirebaseAuth
                                                    .instance.currentUser
                                                    ?.reauthenticateWithCredential(
                                                        cred);
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser?.uid)
                                                    .set({
                                                  'email': FirebaseAuth.instance
                                                      .currentUser?.email,
                                                  'id': FirebaseAuth.instance
                                                      .currentUser?.uid,
                                                  'name': name,
                                                  'password':
                                                      updatedPassword.text,
                                                  'phone': phone,
                                                });
                                                Navigator.of(context).pop();
                                              } on FirebaseAuthException catch (e) {
                                                if (e.code ==
                                                    'wrong-password') {
                                                  print(
                                                      'The old password provided is incorrect.');
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                          'Incorrect Password'),
                                                      content: Text(
                                                          'The old password you provided is incorrect.'),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    246,
                                                                    121,
                                                                    82,
                                                                    1),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: Text('OK'),
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  print(
                                                      'Something went wrong: ${e.message}');
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      246, 121, 82, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child:
                                                const Text('Update Password'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: const Color.fromRGBO(246, 121, 82, 1),
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            const Icon(Icons.email),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              data!['email'],
                              style: const TextStyle(color: Colors.black),
                            )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: const Color.fromRGBO(246, 121, 82, 1),
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(width: 20),
                            Expanded(
                                child: Text(
                              data!['phone'],
                              style: const TextStyle(color: Colors.black),
                            )),
                            InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return SimpleDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        titlePadding: const EdgeInsets.all(20),
                                        children: [
                                          TextField(
                                            decoration: const InputDecoration(
                                                hintText: 'Phone'),
                                            controller: updatedPhone,
                                            keyboardType: TextInputType.phone,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              String pass = '';
                                              String name = '';

                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .get()
                                                  .then((value) {
                                                pass = value['password'];
                                                name = value['name'];
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .set({
                                                'email': FirebaseAuth.instance
                                                    .currentUser?.email,
                                                'id': FirebaseAuth
                                                    .instance.currentUser?.uid,
                                                'name': name,
                                                'password': pass,
                                                'phone': updatedPhone.text,
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      246, 121, 82, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text('Update Phone'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
