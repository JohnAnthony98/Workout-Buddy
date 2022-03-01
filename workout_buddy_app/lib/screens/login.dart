import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy_app/screens/home.dart';
import 'package:workout_buddy_app/services/my_colors.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _auth = FirebaseAuth.instance;
  late String value;
  late String email;
  late String password;
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
                  'Log In',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: getPrimarySwatch(),
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
                      labelText: "email",
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
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      labelText: "password",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                ButtonTheme(
                  minWidth: 345.0,
                  height: 50.0,
                  child: logLoading
                      ? ElevatedButton(
                          onPressed: () async {
                            setState(
                              () {
                                logLoading = false;
                              },
                            );
                            try {
                              final newUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              if (newUser != null) {
                                setState(() {
                                  logLoading = true;
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return const MyHomePage();
                                    },
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(
                                () {
                                  logLoading = true;
                                },
                              );
                              print(e);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: getButtonColor()),
                          child: Text('Log In',
                              style: TextStyle(color: getButtonTextColor())),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            backgroundColor: getButtonColor(),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                ButtonTheme(
                  minWidth: 345.0,
                  height: 50.0,
                  child: signLoading
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: getButtonColor()),
                          child: Text('Sign Up',
                              style: TextStyle(color: getButtonTextColor())),
                          onPressed: () async {
                            setState(() {
                              signLoading = false;
                            });
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              if (newUser != null) {
                                setState(
                                  () {
                                    signLoading = true;
                                  },
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return const MyHomePage();
                                    },
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(
                                () {
                                  signLoading = true;
                                },
                              );
                              print(e);
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
