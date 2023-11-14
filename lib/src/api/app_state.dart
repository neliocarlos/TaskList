import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/components/tasklist/task_list_dto.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  Future<DocumentReference> addToTaskBoard(
      String description, String title) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('tasklist')
        .add(<String, dynamic>{
      'title': title,
      'description': description,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });

    return docRef;
  }

  Future<void> deleteTask(String taskId) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    await FirebaseFirestore.instance
        .collection('tasklist')
        .doc(taskId)
        .delete();
  }

  Future<void> updateTask(
      String taskId, String newDescription, String newTitle) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    await FirebaseFirestore.instance.collection('tasklist').doc(taskId).update({
      'description': newDescription,
      'title': newTitle,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _taskListSubscription;
  List<TaskListDto> _taskListArray = [];
  List<TaskListDto> get taskListArray => _taskListArray;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _taskListSubscription = FirebaseFirestore.instance
            .collection('tasklist')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _taskListArray = [];
          for (final document in snapshot.docs) {
            _taskListArray.add(TaskListDto.fromDocument(document));
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _taskListArray = [];
        _taskListSubscription?.cancel();
      }
      notifyListeners();
    });
  }
}
