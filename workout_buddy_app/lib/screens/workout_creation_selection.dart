// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy_app/screens/workout_creation.dart';
import 'package:workout_buddy_app/services/my_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutCreationSelection extends StatefulWidget {
  const WorkoutCreationSelection({Key? key, title}) : super(key: key);

  @override
  _WorkoutCreationSelection createState() => _WorkoutCreationSelection();
}

class _WorkoutCreationSelection extends State<WorkoutCreationSelection> {
  DateTime viewingWorkoutDay = DateTime.now();
  final User? user = FirebaseAuth.instance.currentUser;
  String user_error_message = "";
  String username = "";
  bool user_selected = false;

  Future<QuerySnapshot> getUser(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("Username", isEqualTo: username)
        .get();
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
        title: const Text("User and Date Selection"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 35,
                width: 300,
                child: Text(getDate(),
                    style: TextStyle(fontSize: 14, color: getButtonTextColor()),
                    textAlign: TextAlign.center)),
            if (user_selected)
              FutureBuilder(
                  future: getUser(username),
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
                      bool is_user_valid = false;
                      if (snapshot.data!.size > 0) {
                        is_user_valid = true;
                      } else {
                        is_user_valid = false;
                        user_selected = false;
                        return Text("User doesn't exist!",
                            style: TextStyle(
                                fontSize: 16, color: getButtonTextColor()));
                      }
                      bool is_date_valid = false;
                      if (viewingWorkoutDay.isAfter(DateTime.now())) {
                        is_date_valid = true;
                      } else {
                        user_selected = false;
                        return Text("Date is in the past!",
                            style: TextStyle(
                                fontSize: 16, color: getButtonTextColor()));
                      }
                      bool is_valid = is_date_valid && is_user_valid;
                      if (is_valid) {
                        Future.delayed(const Duration(milliseconds: 0))
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkoutCreation(
                                      clientID: snapshot.data!.docs.first.id,
                                      workoutDay: getDate()),
                                )));
                        return Text("User Found!",
                            style: TextStyle(
                                fontSize: 16, color: getButtonTextColor()));
                      }
                    }
                  }),
            const SizedBox(
              height: 20,
            ),
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
                    labelText: "Client Username",
                    labelStyle: TextStyle(
                      color: getLoginTextColor(),
                    ),
                  ),
                  onChanged: (value) {
                    username = value;
                  },
                )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                user_selected = true;
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 50), primary: getButtonColor()),
              child: Text("Select User and Date",
                  style: TextStyle(fontSize: 22, color: getButtonTextColor()),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: viewPreviousDay,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50), primary: getButtonColor()),
                child: Text("Previous Day",
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
                child: Text("Next Day",
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
