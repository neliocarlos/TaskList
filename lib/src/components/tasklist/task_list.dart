import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/components/modal/create_modal.dart';
import 'package:gtk_flutter/src/components/modal/update_modal.dart';

import 'task_list_dto.dart';

class TaskList extends StatefulWidget {
  const TaskList(
      {required this.addTask,
      required this.updateTask,
      required this.deleteTask,
      required this.tasks,
      super.key});

  final FutureOr<DocumentReference> Function(
      String title, String date, String color) addTask;
  final Future<void> Function(
          String taskId, String newTitle, String newDate, String newColor)
      updateTask;
  final Future<void> Function(String taskId) deleteTask;
  final List<TaskListDto> tasks;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_TaskListState');
  final _title = TextEditingController();
  final _date = TextEditingController();
  final _color = TextEditingController();

  DateTime _dateTime = DateTime.now();

  void _showDatePicker() async {
    DateTime? pickedDate = await _selectDate(context);
    if (pickedDate != null && pickedDate != _dateTime) {
      setState(() {
        _dateTime = pickedDate;
        _date.text = '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}';
        _dateTime = DateTime.now();
      });
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime currentDate = _dateTime;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    return pickedDate;
  }

  void _setEditFormValues(TaskListDto task) {
    _title.text = task.title;
    _date.text = task.date;
    _color.text = task.color;
    _selectedColor = task.color;
  }

  void _showEditModal(BuildContext context, TaskListDto task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return UpdateModal(
          titleController: _title,
          dateController: _date,
          colorController: _color,
          selectedColor: _selectedColor,
          onUpdate: (String newTitle, String newDate, String newColor) async {
            await widget.updateTask(task.id, newTitle, newDate, newColor);
          },
        );
      },
    );
  }

  void _showCreateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CreateModal(
          titleController: _title,
          dateController: _date,
          colorController: _color,
          selectedColor: _selectedColor,
          onCreate: (String title, String date, String color) async {
            await widget.addTask(title, date, color);
          },
        );
      },
    );
  }

  String _selectedColor = 'Azul';

  Color getColorFromName(String colorName) {
    switch (colorName) {
      case 'Azul':
        return Colors.blue;
      case 'Vermelho':
        return Colors.red;
      case 'Verde':
        return Colors.green;
      case 'Amarelo':
        return Colors.yellow.shade700;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.tasks.isEmpty)
                    Center(
                      heightFactor: 22,
                      child: Text(
                        'Está meio vazio por aqui, não acha?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  const SizedBox(height: 8),
                  for (var task in widget.tasks)
                    if (task.userId == FirebaseAuth.instance.currentUser!.uid)
                      Card(
                        color: getColorFromName(task.color),
                        child: ListTile(
                          textColor: Colors.white,
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            task.date,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                iconSize: 30,
                                onPressed: () async {
                                  String taskId = task.id;
                                  await widget.deleteTask(taskId);
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  _setEditFormValues(task);
                                  _showEditModal(context, task);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 12),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(style: BorderStyle.none),
                      color: Colors.blue,
                    ),
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        _showCreateModal(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
