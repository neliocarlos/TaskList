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
                  const SizedBox(height: 8),
                  for (var task in widget.tasks)
                    Card(
                      color: Colors.blue,
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
                          task.description,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        trailing: IconButton(
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
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Header('Adicione nova tarefa'),
                                  const SizedBox(height: 72),
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
                                  const SizedBox(height: 24),
                                  Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          DocumentReference docRef =
                                              await widget.addTask(_title.text,
                                                  _description.text);
                                          String taskId = docRef.id;
                                          _title.clear();
                                          _description.clear();
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text(
                                        'Salvar',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
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
