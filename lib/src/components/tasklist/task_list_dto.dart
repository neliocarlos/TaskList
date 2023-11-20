import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListDto {
  TaskListDto(
      {required this.id,
      required this.title,
      required this.date,
      required this.color});

  final String id;
  final String title;
  final String date;
  final String color;

  factory TaskListDto.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TaskListDto(
      id: doc.id,
      title: data['title'] as String,
      date: data['date'] as String,
      color: data['color'] as String,
    );
  }
}
