import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/task_detail.dart';
import 'package:get/get.dart';
import 'GetX/getX_class.dart';
import 'model_classes/model_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController controller = Get.put(TaskController());
  String? profileImageUrl;
  String? userName;
  final user = FirebaseAuth.instance.currentUser;
  late double screenWidth = MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Obx(
                  () => Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            controller.profileImageUrl.value != null
                            ? NetworkImage(controller.profileImageUrl.value!)
                            : null,
                        child: controller.profileImageUrl.value == null
                            ? const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.userName.value ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            controller.userEmail.value ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.044,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (controller.allTasks.isEmpty) {
                    return Center(
                      child: Text(
                        "Task Not Found",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Incomplete Task",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.incompleteTasks.length,
                        itemBuilder: (context, index) {
                          Todo inputtask = controller.incompleteTasks[index];
                          return Card(
                            child: ListTile(
                              leading: inputtask.isPin == true
                                  ? Icon(Icons.push_pin, color: Colors.red)
                                  : null,
                              title: Text(
                                inputtask.task.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDetail(todo: inputtask),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Text(
                        "Completed Tasks",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.completedTasks.length,
                        itemBuilder: (context, index) {
                          Todo inputtask = controller.completedTasks[index];
                          return Card(
                            child: ListTile(
                              leading: inputtask.isPin == true
                                  ? Icon(Icons.push_pin, color: Colors.red)
                                  : null,
                              title: Text(
                                inputtask.task.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDetail(todo: inputtask),
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
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
