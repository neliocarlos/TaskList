import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../auth/widgets.dart';
import 'task_list_dto.dart';

class TaskList extends StatefulWidget {
  const TaskList(
      {required this.addTask,
      required this.deleteTask,
      required this.tasks,
      super.key});

  final FutureOr<DocumentReference> Function(String title, String description)
      addTask;
  final Future<void> Function(String taskId) deleteTask;
  final List<TaskListDto> tasks;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_TaskListState');
  final _title = TextEditingController();
  final _description = TextEditingController();

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
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(
                      hintText: 'Título da Atividade',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Escreva um título para continuar';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _description,
                    decoration: const InputDecoration(
                      hintText: 'Descreva a atividade',
                    ),
                  ),
                  const SizedBox(width: 8, height: 12),
                  SizedBox(
                      child: StyledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        DocumentReference docRef = await widget.addTask(
                            _title.text, _description.text);
                        String taskId = docRef.id;
                        _title.clear();
                        _description.clear();
                      }
                    },
                    child: const Icon(Icons.add),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (var task in widget.tasks)
            Card(
              child: ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: IconButton(
                  onPressed: () async {
                    String taskId = task.id;
                    await widget.deleteTask(taskId);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 219, 22, 18),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      );
    });
  }
}
