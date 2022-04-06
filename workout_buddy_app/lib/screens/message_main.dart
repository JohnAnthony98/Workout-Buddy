import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/my_colors.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class MessageMain extends StatefulWidget {
  const MessageMain({Key? key}) : super(key: key);
  final String title = "Workout Buddy";

  @override
  State<MessageMain> createState() => _MessageMain();
}

class _MessageMain extends State<MessageMain> {
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
          children: const <Widget>[
            Text("This is the Messaging main Page"),
          ],
        ),
      ),
    );
  }
}
