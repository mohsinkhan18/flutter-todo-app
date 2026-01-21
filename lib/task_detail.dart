import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/BottomSheet_Class.dart';
import 'package:to_do_app/model_classes/model_class.dart';
import 'package:to_do_app/task_screen.dart';

import 'bottom_screen.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key,required this.todo});
  final Todo todo;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  TextEditingController task = TextEditingController();
  TextEditingController discription = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Todo data;
  @override
  @override
  void initState() {
    // TODO: implement initState
    data=widget.todo;
  }
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff1253AA),
        leading: IconButton(onPressed:(){
          Navigator.pop(context);
          },
            icon: Icon(Icons.arrow_back_ios,color: Color(0xff63D9F3))),
        title: Text("Task Detail",style: TextStyle(color: Color(0xffFFFFFF)))
      ),
      body:SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1253AA), Color(0xFF05243E)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(
                        child: Text(data.task,style: TextStyle(fontSize: 25,color: Color(0xffFFFFFF)),)),
                    IconButton(onPressed: ()async{
                     await showModalBottomSheet(
                       clipBehavior: Clip.antiAliasWithSaveLayer,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                          context: context, builder: (BuildContext context){
                            return BottomSheetClass(taskModel: data);
                      },
                      );setState(() {
          
                      });
                    },
                        icon:Icon(Icons.edit_note,color:Color(0xffFFFFFF))
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_month,size: 18,color: Color(0xffFFFFFF)),
                    Text(data.date,style: TextStyle(color: Color(0xffFFFFFF)),),
                    Text("   |   ",style: TextStyle(color: Color(0xffFFFFFF)),),
                    Icon(Icons.access_time,size: 18,color: Color(0xffFFFFFF),),
                    Text(data.time,style: TextStyle(color: Color(0xffFFFFFF)),)
                  ],
                ),
                Divider(
                  color: Colors.blueGrey,
                  height: 60,
                  thickness: 2,
                ),
                Text(data.discription,style: TextStyle(color: Color(0xffFFFFFF)),),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.25,
                      height: 71,
                      child: ElevatedButton(
                          onPressed: ()async{
                            await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser?.uid).collection("task").doc(widget.todo.docId).update({"isDone":true});
                            //FirebaseFirestore.instance.collection('user').doc(data.docId).update({"isDone":true});
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>BottomScreen(),
                            ));
                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff05243E),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [Padding(padding: EdgeInsets.all(10)),
                            Icon(Icons.check_circle,color: Color(0xff49EA80)),
                            Text("Done")
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.25,
                      height: 71,
                      child: ElevatedButton(
                        onPressed: (){
                          showDialog(context: context,
                              builder: (context){
                            return AlertDialog(
                              title: Text("Delete"),
                              content: Text("Are you sure to delete permanantly"),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                },
                                    child: Text("NO"),
                                ),
                                TextButton(onPressed: ()async{
                                  await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser?.uid).collection("task").doc(widget.todo.docId).delete();
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomScreen(initialIndex: 1)),
                                      (route)=>false,
                                  );
                                },
                                  child: Text("YES"),
                                ),
                              ],
                            );
                              }
                          );
                          // FirebaseFirestore.instance.collection("Task").doc(data.docId).delete();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff05243E),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [Padding(padding: EdgeInsets.all(10)),
                            Icon(Icons.delete,color: Color(0xffE76666)),
                            Text("Delete")
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.25,
                      height: 71,
                      child: ElevatedButton(
                        onPressed: ()async{
                          await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser?.uid).collection("task").doc(widget.todo.docId).update({"isPin":true});
                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff05243E),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          //padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [Padding(padding: EdgeInsets.all(10)),
                            Icon(Icons.push_pin_rounded,color: Colors.yellow),
                            Text("Pin")
                          ],
                        ),
                      ),
                    ),
          
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
