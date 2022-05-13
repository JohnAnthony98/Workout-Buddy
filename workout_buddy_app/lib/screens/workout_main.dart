// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutMain extends StatefulWidget {
  const WorkoutMain({Key? key, title}) : super(key: key);

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

  String parseWorkout(String workout) {
    List<String> splitted = workout.split(":");
    return splitted[0] + " x " + splitted[1];
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * (5 / 8),
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
                      String workout = "";
                      for (int i = 1;
                          i <= snapshot.data?.docs.first['NumSets'];
                          i++) {
                        var exercises = snapshot.data?.docs.first['Set$i'];
                        workout += "Set $i has ${exercises[0]} reps\n";
                        for (int x = 1; x < exercises.length; x++) {
                          workout += "\t\t" + parseWorkout(exercises[x]) + "\n";
                        }
                        workout = workout + "\n";
                      }
                      return Container(
                          child: Text("${getDate()}\n\n" + workout,
                              style: TextStyle(
                                  fontSize: 16, color: getButtonTextColor())));
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: viewPreviousDay,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50), primary: getButtonColor()),
                child: Text("Previous Workout",
                    style: TextStyle(fontSize: 22, color: getButtonTextColor()),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(
                width: 10.0,
              ),
              ElevatedButton(
                onPressed: viewNextDay,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50), primary: getButtonColor()),
                child: Text("Next Workout",
                    style: TextStyle(fontSize: 22, color: getButtonTextColor()),
                    textAlign: TextAlign.center),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
