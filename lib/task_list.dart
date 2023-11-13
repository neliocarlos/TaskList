import 'dart:async';

import 'package:flutter/material.dart';

import 'src/widgets.dart';
import 'task_list_dto.dart';

class TaskList extends StatefulWidget {
  const TaskList({required this.addTask, required this.tasks, super.key});

  final FutureOr<void> Function(String title, String description) addTask;
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
                    // width: constraints.maxWidth * .1,
                    child: StyledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await widget.addTask(_title.text, _description.text);
                          _title.clear();
                          _description.clear();
                        }
                      },
                      child: const Icon(Icons.add),
                      
                          
                          // SizedBox(width: 4),
                          // Text('Adicionar'),
                        
                      )
                    ),
                  
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (var task in widget.tasks)
            // Paragraph('${task.title}: ${task.description}'),
            Card(
                  child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: IconButton(onPressed: () { null; }, 
                    icon: const Icon(Icons.check_circle),),),
                ),
          const SizedBox(height: 8),
        ],
      );
    });
  }
}
