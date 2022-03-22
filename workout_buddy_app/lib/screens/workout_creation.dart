// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy_app/services/my_colors.dart';

class WorkoutCreation extends StatefulWidget {
  const WorkoutCreation({Key? key, title}) : super(key: key);

  @override
  _WorkoutCreation createState() => _WorkoutCreation();
}

class _WorkoutCreation extends State<WorkoutCreation> {
  DateTime viewingWorkoutDay = DateTime.now();
  final User? user = FirebaseAuth.instance.currentUser;

  late String exercise;
  late String reps;

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

  void submitWorkout() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Trainer workout view"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                      labelText: "Workout",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      exercise = value;
                    },
                  )),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  height: 30,
                  width: 75,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: getLoginBorderColor()),
                      ),
                      labelText: "Reps",
                      labelStyle: TextStyle(
                        color: getLoginTextColor(),
                      ),
                    ),
                    onChanged: (value) {
                      reps = value;
                    },
                  )),
            ]),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: submitWorkout,
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 50), primary: getButtonColor()),
              child: Text("Add Set to Workout",
                  style: TextStyle(fontSize: 22, color: getButtonTextColor()),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: submitWorkout,
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 50), primary: getButtonColor()),
              child: Text("Finish Workout",
                  style: TextStyle(fontSize: 22, color: getButtonTextColor()),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
