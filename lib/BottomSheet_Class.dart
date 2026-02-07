import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model_classes/model_class.dart';

class BottomSheetClass extends StatefulWidget {
  final Todo? taskModel;

  const BottomSheetClass({super.key, this.taskModel});

  @override
  State<BottomSheetClass> createState() => _BottomSheetClassState();
}

class _BottomSheetClassState extends State<BottomSheetClass> {
 // late GlobalKey<FormState> _formKey=TextEditingController();
  late TextEditingController task = TextEditingController();
  late TextEditingController discription= TextEditingController();
  late TextEditingController date=TextEditingController();
  late TextEditingController time=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.taskModel != null) {
      task.text = widget.taskModel?.task ?? "";
      discription.text = widget.taskModel?.discription ?? "";
      date.text = widget.taskModel?.date ?? "";
      time.text = widget.taskModel?.time ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: task,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff05243E),
                        hintText: 'Task',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.task, color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: discription,
                      maxLines: 6,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff05243E),
                        hintText: 'Discription',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 42,
                            //width: 170,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              onTap: () async {
                                DateTime? datePicked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2027),
                                );

                                if (datePicked != null) {
                                  date.text =
                                      "${datePicked.day}-${datePicked.month}-${datePicked.year}";
                                }
                              },
                              controller: date,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xff05243E),
                                hintText: 'Date',
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.date_range,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 42,
                            //width: 170,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  initialEntryMode: TimePickerEntryMode.input,
                                );
                                if (pickedTime != null) {
                                  time.text =
                                      "${pickedTime.hour}:${pickedTime.minute}";
                                }
                              },
                              controller: time,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xff05243E),
                                hintText: 'Time',
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            //width: 165,
                            child: FloatingActionButton.extended(
                              label: Text("Cancel"),
                              foregroundColor: Color(0xff05243E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                                side: BorderSide(
                                  color: Color(0xff0EA5E9),
                                  width: 2,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            //width: 170,
                            child: FloatingActionButton.extended(
                              label: Text(widget.taskModel == null ? "Create" : "Update",),
                              foregroundColor: Color(0xffFFFFFF),
                              backgroundColor: Color(0xff0EA5E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {

                                    if ( widget.taskModel == null) {
                                      var docId = FirebaseFirestore.instance.collection("user").doc().id;
                                      String? userId=FirebaseAuth.instance.currentUser?.uid;
                                      if(userId==null){
                                        return;
                                      }
                                      Todo newTask = Todo(
                                        task: task.text,
                                        discription:discription.text,
                                        date:date.text,
                                        time:time.text,
                                        docId: docId,
                                        isDone: false,
                                        isPin: false,
                                      );

                                      await FirebaseFirestore.instance
                                          .collection("user")
                                          .doc(userId).collection("task").doc(docId)
                                          .set(newTask.toJson());

                                    } else {
                                      widget.taskModel!.task=task.text;
                                      widget.taskModel!.date=date.text;
                                      widget.taskModel!.time=time.text;
                                      widget.taskModel!.discription=discription.text;
                                       FirebaseFirestore.instance
                                          .collection("user").doc(FirebaseAuth.instance.currentUser!.uid).collection("task")
                                          .doc(widget.taskModel!.docId)
                                          .update({
                                        "task":task.text,
                                        "discription":discription.text,
                                        "date": date.text,
                                        "time": time.text,
                                      });
                                    }

                                    Navigator.pop(context);
                                  }setState(() {

                                  });
                                }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
