import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_app/bottom_screen.dart';

import 'model_classes/model_class.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  TextEditingController date = TextEditingController();
  TextEditingController task = TextEditingController();
  TextEditingController discription = TextEditingController();
  TextEditingController time = TextEditingController();

  DateTime todayvariable = DateTime.now();
  void onDaySelected(DateTime day, DateTime focuseDay) {
    setState(() {
      todayvariable = day;
      date.text = DateFormat('d MMMM yyyy').format(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1253AA),
        title: Text(
          "Manage Your Time",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1253AA), Color(0xff05243E)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(50)),
              TableCalendar(
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.lightBlueAccent),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                selectedDayPredicate: (day) => isSameDay(day, todayvariable),
                focusedDay: DateTime.now(),
                firstDay: DateTime(2022),
                lastDay: DateTime(2030),
                onDaySelected: onDaySelected,
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Set task for ${DateFormat('d MMMM yyyy').format(todayvariable)}",
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                // width: 230,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: task,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xff05243E),
                                    hintText: 'Task',
                                    hintStyle: TextStyle(color: Colors.white),
                                    //prefixIcon: Icon(Icons.task, color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: 45,
                              //width: 130,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() async {
                                    try {
                                      var documentsId = FirebaseFirestore
                                          .instance
                                          .collection("user")
                                          .doc()
                                          .id;
                                      String? userId = FirebaseAuth
                                          .instance
                                          .currentUser
                                          ?.uid;
                                      if (userId == null) {
                                        return;
                                      }
                                      Todo inputtask = Todo(
                                        task: task.text,
                                        discription: discription.text,
                                        date: date.text,
                                        time: time.text,
                                        docId: documentsId,
                                        isDone: false,
                                      );
                                      await FirebaseFirestore.instance
                                          .collection("user")
                                          .doc(userId)
                                          .collection("task")
                                          .doc(documentsId)
                                          .set(inputtask.toJson());
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BottomScreen(initialIndex: 1),
                                        ),
                                      );
                                      Get.snackbar(
                                        "Task",
                                        "Added Successfuly",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.white,
                                        colorText: Colors.black,
                                        duration: Duration(seconds: 2),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text("Sending")),
                                      );
                                    }
                                    ;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff0EA5E9),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                child: Text("Submit"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
