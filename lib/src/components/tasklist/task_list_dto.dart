import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListDto {
  TaskListDto(
      {required this.id, required this.title, required this.description});

  final String id;
  final String title;
  final String description;

  factory TaskListDto.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TaskListDto(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
    );
  }
}
