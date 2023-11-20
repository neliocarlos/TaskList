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

  final FutureOr<DocumentReference> Function(String title, String date) addTask;
  final Future<void> Function(String taskId) deleteTask;
  final List<TaskListDto> tasks;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_TaskListState');
  final _title = TextEditingController();
  final _date = TextEditingController();

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
                          task.date,
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
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _date,
                                          enabled: false,
                                          decoration: const InputDecoration(
                                            hintText: 'Data da atividade',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              24), // Adicione algum espaço entre os widgets
                                      IconButton(
                                        onPressed: _showDatePicker,
                                        icon: Icon(
                                          Icons.calendar_today,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          DocumentReference docRef =
                                              await widget.addTask(
                                                  _title.text, _date.text);
                                          String taskId = docRef.id;
                                          _title.clear();
                                          _date.clear();
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
