import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:to_do_app/model_classes/model_class.dart';

class ProviderClass extends ChangeNotifier {
  bool isLoading = true;
  bool isProfileLoading= true;

  List<Todo> allTasks = [];
  List<Todo> incompleteTasks = [];
  List<Todo> completedTasks = [];

  final user = FirebaseAuth.instance.currentUser;
  String? profileImageUrl;
  String? userName;
  String? userEmail;

  void getTask() {
    isLoading = true;
    final user = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection("user")
        .doc(user)
        .collection("task")
        .snapshots().listen((snapshot){
       allTasks = snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList();
       incompleteTasks = allTasks.where((task) => task.isDone == false).toList();
       completedTasks = allTasks.where((task) => task.isDone == true).toList();
        isLoading = false;
       notifyListeners();
    });
  }
  void fetchUserProfile()  {
    isProfileLoading=true;
    try {
       FirebaseFirestore.instance
          .collection("user")
          .doc(user!.uid)
          .snapshots().listen((snapshot)
       {
         if (snapshot.exists) {
           var userDoc = snapshot.data();
           profileImageUrl = userDoc?['profile_url'];
           userName = userDoc?['name']??user?.displayName;
           userEmail = userDoc?['email']??user?.email;

         }
         isProfileLoading= false;
         notifyListeners();
      });


    } catch (e) {
      debugPrint("Error fetching profile");
    }
  }
}
