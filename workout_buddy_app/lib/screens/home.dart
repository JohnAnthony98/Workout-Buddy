import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  final String title = "Workout Buddy";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get()
                    .then((value) {
                  if (value.data()?["Role"] == "user") {
                    Navigator.pushNamed(context, "/workout_main");
                  } else {
                    Navigator.pushNamed(context, "/workout_creation_selection");
                  }
                });
              },
              style: ElevatedButton.styleFrom(primary: getButtonColor()),
              child: Text("Workouts",
                  style: TextStyle(fontSize: 26, color: getButtonTextColor())),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              style: ElevatedButton.styleFrom(primary: getButtonColor()),
              child: Text("Chat",
                  style: TextStyle(fontSize: 26, color: getButtonTextColor())),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              style: ElevatedButton.styleFrom(primary: getButtonColor()),
              child: Text("Share",
                  style: TextStyle(fontSize: 26, color: getButtonTextColor())),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              style: ElevatedButton.styleFrom(primary: getButtonColor()),
              child: Text("Friends",
                  style: TextStyle(fontSize: 26, color: getButtonTextColor())),
            ),
          ],
        ),
      ),
    );
  }
}
