import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListDto {
  TaskListDto(
      {required this.id,
      required this.title,
      required this.date,
      required this.color,
      required this.userId,
      required this.initialTime,
      required this.finalTime,
      required this.completed});

  final String id;
  final String title;
  final String date;
  final String color;
  final String userId;
  final String initialTime;
  final String finalTime;
  bool completed;

  factory TaskListDto.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TaskListDto(
      id: doc.id,
      title: data['title'] as String,
      date: data['date'] as String,
      color: data['color'] as String,
      userId: data['userId'] as String,
      initialTime: data['initialTime'] as String,
      finalTime: data['finalTime'] as String,
      completed: data['completed'] as bool,
    );
  }
}
