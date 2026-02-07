import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/model_classes/model_class.dart';

class TaskController extends GetxController {
  var isLoading = true.obs;
  var isProfileLoading = true.obs;

  var allTasks = <Todo>[].obs;
  var incompleteTasks = <Todo>[].obs;
  var completedTasks = <Todo>[].obs;

  final user = FirebaseAuth.instance.currentUser;
  var profileImageUrl = RxnString();
  var userName = RxnString();
  var userEmail = RxnString();

  @override
  void onInit() {
    super.onInit();
    getTask();
    fetchUserProfile();
  }

  void getTask() {
    isLoading.value = true;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection("task")
        .snapshots()
        .listen((snapshot) {
      allTasks.value = snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList();
      incompleteTasks.value = allTasks.where((task) => task.isDone == false).toList();
      completedTasks.value = allTasks.where((task) => task.isDone == true).toList();

      isLoading.value = false;
    });
  }

  void fetchUserProfile() {
    isProfileLoading.value = true;

    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        profileImageUrl.value = data?['profile_url'];
        userName.value = data?['name'] ?? user?.displayName;
        userEmail.value = data?['email'] ?? user?.email;
      }

      isProfileLoading.value = false;
    });
  }
}
