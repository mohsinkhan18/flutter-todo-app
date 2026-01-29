import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/provider/provider_class.dart';
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
    Future.microtask((){
      final provider = context.read<ProviderClass>();
      provider.getTask();
      provider.fetchUserProfile();
    });
   // fetchUserProfile();
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
                    Consumer<ProviderClass>(builder: (context, provider,child) {   //consumer
                        if (provider.isProfileLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Row(
                          children: [
                            CircleAvatar(radius: 40,
                              backgroundImage: provider.profileImageUrl != null
                                  ? NetworkImage(provider.profileImageUrl!)
                                  : null,
                              child: provider.profileImageUrl == null
                                  ? const Icon(
                                  Icons.person, size: 30, color: Colors.white)
                                  : null,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(provider.userName??"user name",
                                  style: TextStyle(color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,),
                                ),
                                Text(provider.userEmail??"email@gmail.com",
                                  style: TextStyle(color: Colors.white,
                                    fontSize: screenWidth * 0.044,),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                SizedBox(height: 20),
                Consumer<ProviderClass>(
               // StreamBuilder<QuerySnapshot>(
                  //stream: FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser?.uid).collection("task").snapshots(),
                  builder: (context, provider,child) {
                    if (provider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Incomplete Task", style: TextStyle(fontSize: 20, color: Colors.white)),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:provider.incompleteTasks.length,
                          itemBuilder: (context, index) {
                            Todo inputtask = provider.incompleteTasks[index];
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
                          itemCount: provider.completedTasks.length,
                          itemBuilder: (context, index) {
                            Todo inputtask = provider.completedTasks[index];
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
