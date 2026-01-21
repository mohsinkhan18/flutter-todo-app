import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/task_detail.dart';

import 'model_classes/model_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? profileImageUrl;
  String? userName;
  final user= FirebaseAuth.instance.currentUser;
  late double screenWidth = MediaQuery.of(context).size.width;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (user == null) return;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          profileImageUrl = userDoc.get('profile_url');
          userName = userDoc.data().toString().contains('name') ? userDoc.get('name') : null;
        });
      }
    } catch (e) {
      debugPrint("Error fetching profile");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(height: double.infinity,width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1253AA), Color(0xff05243E)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [ SizedBox(height: 60),
                    Row(
                      children: [
                        CircleAvatar(radius: 40,
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl!)
                              : null,
                            child: profileImageUrl == null
                                ? const Icon(Icons.person, size: 30, color: Colors.white)
                                : null,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(FirebaseAuth.instance.currentUser!.displayName.toString(),
                              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,),
                            ),
                            Text(FirebaseAuth.instance.currentUser!.email.toString(),
                              style: TextStyle(color: Colors.white,fontSize: screenWidth * 0.044,),
                            ),
                          ],
                        ),
                      ],
                    ),
                //     SizedBox(height: 20),
                //     Text("Group Tasks",style: TextStyle(fontSize: 20,color: Colors.white),
                //     ),
                // SizedBox(height: 20),
                // Row(
                //   children: [
                //     SizedBox(height: 106,width: 160,
                //       child: Card(color: Colors.white,
                //       ),
                //     ),
                //     SizedBox(width: 30),
                //     SizedBox(height: 106,width: 160,
                //       child: Card(color: Colors.white,
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser?.uid).collection("task").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("something Error"));
                    }
                    List<Todo> allTasks = snapshot.data!.docs.map((doc) => Todo.fromJson(doc.data() as Map<String, dynamic>)).toList();
                    List<Todo> incompleteTasks = allTasks.where((task) => task.isDone == false).toList();
                    List<Todo> completedTasks = allTasks.where((task) => task.isDone == true).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Incomplete Task", style: TextStyle(fontSize: 20, color: Colors.white)),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: incompleteTasks.length,
                          itemBuilder: (context, index) {
                            Todo inputtask = incompleteTasks[index];
                            return Card(
                              child: ListTile(
                                leading: inputtask.isPin==true?Icon(Icons.push_pin,color: Colors.red,):null,
                                title: Text(inputtask.task.toString(), style: TextStyle(fontSize: 20)),
                                subtitle: Row(
                                  children: [
                                    Text(inputtask.date.toString()),
                                    Text("  |  "),
                                    Text(inputtask.time.toString()),
                                  ],
                                ),
                                trailing: IconButton(icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetail(todo: inputtask),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        Text("Completed Tasks", style: TextStyle(fontSize: 20, color: Colors.white)),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: completedTasks.length,
                          itemBuilder: (context, index) {
                            Todo inputtask = completedTasks[index];
                            return Card(
                              child: ListTile(
                                leading: inputtask.isPin==true?Icon(Icons.push_pin,color: Colors.red):null,
                                title: Text(inputtask.task.toString(), style: TextStyle(fontSize: 20)),
                                subtitle: Row(
                                  children: [
                                    Text(inputtask.date.toString()),
                                    Text("  |  "),
                                    Text(inputtask.time.toString()),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetail(todo: inputtask),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
