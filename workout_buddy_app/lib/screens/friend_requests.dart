// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/my_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({Key? key}) : super(key: key);

  @override
  State<FriendRequests> createState() => _FriendRequests();
}

class _FriendRequests extends State<FriendRequests> {
  final User? user = FirebaseAuth.instance.currentUser;
  String new_friend_name = "";

  Future<DocumentSnapshot> getMyUserData() {
    return FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  }

  Future<QuerySnapshot> getUserData(String username) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("Username", isEqualTo: username)
        .get();
  }

  void sendRequest() async {
    //Add new friend to your pending
    Future<DocumentSnapshot<Map<String, dynamic>>> my_user =
        FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
    my_user.then((value) => addToPending(value));
    //Add yourself to new friend's incoming
    Future<QuerySnapshot<Map<String, dynamic>>> new_friend = FirebaseFirestore
        .instance
        .collection("users")
        .where("Username", isEqualTo: new_friend_name)
        .get();
    new_friend.then(
        (value) => my_user.then((myself) => addToIncoming(value, myself)));
  }

  void addToPending(DocumentSnapshot<Map<String, dynamic>> myself) {
    List pending_friends = myself.get("PendingFriends");
    pending_friends.add(new_friend_name);
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .update({"PendingFriends": pending_friends});
  }

  void addToIncoming(QuerySnapshot<Map<String, dynamic>> new_friend,
      DocumentSnapshot<Map<String, dynamic>> myself) {
    List incoming_friends = new_friend.docs.first.get("PendingFriends");
    incoming_friends.add(myself.get("Username"));
    FirebaseFirestore.instance
        .collection("users")
        .doc(new_friend.docs.first.id)
        .update({"IncomingFriends": incoming_friends});
    //this should run after pending is updated, so set state to get new list
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        title: const Text("Friend Requests"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20.0,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  height: 30,
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      labelText: "New Friend's Username",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      new_friend_name = value;
                    },
                  )),
              const SizedBox(width: 20),
              SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      sendRequest();
                    },
                    style: ElevatedButton.styleFrom(primary: getButtonColor()),
                    child: Text("add",
                        style: TextStyle(
                            fontSize: 15, color: getButtonTextColor())),
                  )),
            ]),
            const SizedBox(
              height: 20.0,
            ),
            const Text("Incoming Friend Requests"),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              width: 400,
              decoration: BoxDecoration(
                  border: Border.all(color: getButtonColor(), width: 5.0)),
              child: FutureBuilder(
                future: getMyUserData(),
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
                    var friends = snapshot.data!.get("IncomingFriends");
                    for (String f in friends) {
                      friendslist = friendslist + f + "\n";
                    }
                    return Text(friendslist);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text("Pending Friend Requests"),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              width: 400,
              decoration: BoxDecoration(
                  border: Border.all(color: getButtonColor(), width: 5.0)),
              child: FutureBuilder(
                future: getMyUserData(),
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
                    var friends = snapshot.data!.get("PendingFriends");
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
