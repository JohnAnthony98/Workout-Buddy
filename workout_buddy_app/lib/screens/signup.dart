import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy_app/screens/home.dart';
import 'package:workout_buddy_app/services/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  late String value;
  late String email;
  late String username;
  late String password;
  late String password2;
  late String e;
  bool logLoading = true;
  bool signLoading = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: getBackgroundColor(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: getLoginBorderColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      labelText: "Username",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      username = value;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      labelText: "Re-Enter Password",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      password2 = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                ButtonTheme(
                  minWidth: 345.0,
                  height: 50.0,
                  child: signLoading
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: getLoginBorderColor()),
                          child: Text('Sign Up',
                              style: TextStyle(color: getButtonTextColor())),
                          onPressed: () async {
                            setState(() {
                              signLoading = false;
                            });
                            try {
                              if (password != password2) {
                                throw "password doesnt match";
                              }
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                              //give user a user role
                              FirebaseFirestore.instance
                                  .collection('appusers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .set({
                                "Role": "user",
                                "Username": username,
                                "Friends": [],
                                "IncomingFriends": [],
                                "PendingFriends": []
                              });
                              await FirebaseChatCore.instance
                                  .createUserInFirestore(
                                types.User(
                                  firstName: username,
                                  id: FirebaseAuth.instance.currentUser!.uid,
                                ),
                              );
                              setState(
                                () {
                                  signLoading = true;
                                },
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return const MyHomePage();
                                  },
                                ),
                              );
                            } catch (e) {
                              setState(
                                () {
                                  signLoading = true;
                                },
                              );
                              //print(e);
                            }
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            backgroundColor: getButtonColor(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
