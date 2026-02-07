import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/model_classes/model_class.dart';
import 'package:to_do_app/task_detail.dart';
import 'package:get/get.dart';
import 'BottomSheet_Class.dart';
import 'GetX/getX_class.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController task = TextEditingController();
  TextEditingController discription = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController search = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1253AA), Color(0xff05243E)],
          ),
        ),
        child: Column(
          children: [Padding(padding: EdgeInsets.all(20)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex:2,
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        controller: search,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xff102D53),
                              hintText: 'Search by task title',
                            hintStyle: TextStyle(color: Colors.white),
                            suffixIcon: Icon(Icons.search,color: Colors.white,),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

                          ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff102D53),
                          hintText: 'Sort By', hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
             // child: FutureBuilder<QuerySnapshot>(
               // future: FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser?.uid).collection("task").get(),
               // builder: (context, snapshot)
              child:
               Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if(controller.allTasks.isEmpty){
                    return Center(child: Text("Task Not Found",style: TextStyle(color: Colors.white),
                    ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.allTasks.length,
                    itemBuilder: (context, index) {
                    //var document = snapshot.data!.docs[index].data();
                      Todo inputtask= controller.allTasks[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          child: ListTile(
                            title: Text(inputtask.task.toString(),style: TextStyle(fontSize: 20),),
                               subtitle:  Row(
                                  children: [
                                    Text(inputtask.date.toString()),
                                    Text("  |  "),
                                    Text(inputtask.time.toString()),
                                    // Text(document['time']),
                                  ],
                                ),
                            trailing: IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>TaskDetail(todo: inputtask,)));
                            },
                                icon: Icon(Icons.arrow_forward_ios))
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff63D9F3),
        onPressed: ()async {
          await showModalBottomSheet(
            isScrollControlled: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
            context: context,
            builder: (BuildContext context) {
              return BottomSheetClass();
            },
          );
          setState(() {

          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

