import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsList();
}

class _FriendsList extends State<FriendsList> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot> getUserData() {
    return FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        title: const Text("Friends"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/friend_requests");
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 50), primary: getButtonColor()),
              child: Text("Friend Requests",
                  style: TextStyle(fontSize: 15, color: getButtonTextColor()),
                  textAlign: TextAlign.center),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              width: 400,
              decoration: BoxDecoration(
                  border: Border.all(color: getButtonColor(), width: 5.0)),
              child: FutureBuilder(
                future: getUserData(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitWave(
                        color: getButtonTextColor(),
                        size: 50.0,
                      ),
                    );
                  } else {
                    String friendslist = "";
                    var friends = snapshot.data!.get("Friends");
                    for (String f in friends) {
                      friendslist = friendslist + f + "\n";
                    }
                    return Text(friendslist);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
