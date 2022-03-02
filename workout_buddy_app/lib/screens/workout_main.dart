import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutMain extends StatefulWidget {
  WorkoutMain({Key? key, title}) : super(key: key);

  @override
  _WorkoutMain createState() => _WorkoutMain();
}

class _WorkoutMain extends State<WorkoutMain> {
  DateTime viewingWorkoutDay = DateTime.now();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<QuerySnapshot> getWorkout(String date, String? user_id) {
    var returned_workout = FirebaseFirestore.instance
        .collection('User_Workouts')
        .where("UserID", isEqualTo: user_id)
        .where("Date", isEqualTo: date)
        .get();
    return returned_workout;
  }

  String getDate() {
    return viewingWorkoutDay.month.toString() +
        "/" +
        viewingWorkoutDay.day.toString() +
        "/" +
        viewingWorkoutDay.year.toString();
  }

  void viewPreviousDay() {
    setState(() {
      viewingWorkoutDay = viewingWorkoutDay.subtract(const Duration(hours: 24));
    });
  }

  void viewNextDay() {
    setState(() {
      viewingWorkoutDay = viewingWorkoutDay.add(const Duration(hours: 24));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Workouts!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: getButtonColor(), width: 5.0)),
              child: FutureBuilder(
                future: getWorkout(getDate(), user?.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitWave(
                        color: getButtonTextColor(),
                        size: 50.0,
                      ),
                    );
                  } else {
                    if (snapshot.data?.size != 0 && !snapshot.hasError) {
                      return Text(
                          "${getDate()}\n${snapshot.data?.docs.first['Workout']}",
                          style: TextStyle(
                              fontSize: 16, color: getButtonTextColor()));
                    } else {
                      return Text(
                          "${getDate()}\nThere is no workout for Today!",
                          style: TextStyle(
                              fontSize: 16, color: getButtonTextColor()));
                    }
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: viewPreviousDay,
              child: Text("Previous Workout",
                  style: TextStyle(fontSize: 26, color: getButtonTextColor())),
            ),
            ElevatedButton(
              onPressed: viewNextDay,
              child: Text("Next Workout",
                  style: TextStyle(fontSize: 26, color: getButtonTextColor())),
            ),
          ],
        ),
      ),
    );
  }
}
