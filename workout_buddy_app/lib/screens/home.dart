import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/my_colors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

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
                Navigator.pushNamed(context, "/workout_main");
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
