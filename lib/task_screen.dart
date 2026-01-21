import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/model_classes/model_class.dart';
import 'package:to_do_app/task_detail.dart';

import 'BottomSheet_Class.dart';

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
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser?.uid).collection("task").get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.hasError){
                    return Center(child: Text("something Erro"),);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                    //var document = snapshot.data!.docs[index].data();
                      Todo inputtask= Todo.fromJson(snapshot.data!.docs[index].data() as Map<String,dynamic>);
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

// class BottomSheetClass extends StatelessWidget {
//   const BottomSheetClass({
//     super.key,
//     required GlobalKey<FormState> formKey,
//     required this.task,
//     required this.discription,
//     required this.date,
//     required this.time,
//   }) : _formKey = formKey;
//
//   final GlobalKey<FormState> _formKey;
//   final TextEditingController task;
//   final TextEditingController discription;
//   final TextEditingController date;
//   final TextEditingController time;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(30.0),
//       child:
//       //BottomsheetClass(),
//       Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextFormField(style: TextStyle(color: Colors.white),
//                 controller: task,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Color(0xff05243E),
//                   hintText: 'Task',
//                   hintStyle: TextStyle(color: Colors.white),
//                   prefixIcon: Icon(Icons.task, color: Colors.white),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),
//               TextFormField(style: TextStyle(color: Colors.white),
//                 controller: discription,
//                 maxLines: 6,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Color(0xff05243E),
//                   hintText: 'Discription',
//                   hintStyle: TextStyle(color: Colors.white),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30),
//               Row(
//                 children: [
//                   SizedBox(
//                     height: 42,
//                     width: 170,
//                     child: TextFormField(style: TextStyle(color: Colors.white),
//                       onTap: () async {
//                         DateTime? datePicked = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(2023),
//                             lastDate: DateTime(2027));
//
//                         if(datePicked!=null){
//                           date.text="${datePicked.day}-${datePicked.month}-${datePicked.year}";
//                         }
//                       },
//                       controller: date,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Color(0xff05243E),
//                         hintText: 'Date',
//                         hintStyle: TextStyle(color: Colors.white),
//                         prefixIcon: Icon(
//                           Icons.date_range,
//                           color: Colors.white,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   SizedBox(
//                     height: 42,
//                     width: 170,
//                     child: TextFormField(style: TextStyle(color: Colors.white),
//                       onTap: () async {
//                       TimeOfDay? pickedTime = await showTimePicker(
//                           context: context,
//                           initialTime: TimeOfDay.now(),
//                         initialEntryMode: TimePickerEntryMode.input);
//                       if(pickedTime!=null){
//                         time.text="${pickedTime.hour}:${pickedTime.minute}";
//                       }
//                       },
//                       controller: time,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Color(0xff05243E),
//                         hintText: 'Time',
//                         hintStyle: TextStyle(color: Colors.white),
//                         prefixIcon: Icon(
//                           Icons.access_time,
//                           color: Colors.white,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               Row(
//                 children: [
//                   SizedBox(
//                     height: 45,
//                     width: 165,
//                     child: FloatingActionButton.extended(
//                       label: Text("Cancel"),
//                       foregroundColor: Color(0xff05243E),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(9),
//                         side: BorderSide(
//                           color: Color(0xff0EA5E9),
//                           width: 2,
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                   SizedBox(width: 15),
//                   SizedBox(
//                     height: 46,
//                     width: 167,
//                     child: FloatingActionButton.extended(
//                       label: Text("Create"),
//                       foregroundColor: Color(0xffFFFFFF),
//                       backgroundColor: Color(0xff0EA5E9),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(9),
//                       ),
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           var documentsId=FirebaseFirestore.instance.collection("Task").doc().id;
//                           // Map<String, dynamic> data = {
//                           //   "task": task.text,
//                           //   "discription": discription.text,
//                           //   "date": date.text,
//                           //   "time": time.text,
//                           // };
//                           Todo inputtask = Todo(task: task.text, discription: discription.text,
//                               date: date.text, time: time.text, docId: documentsId, isDone: false);
//                           await FirebaseFirestore.instance
//                               .collection("Task").doc(documentsId)
//                               .set(inputtask.toJson());
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
