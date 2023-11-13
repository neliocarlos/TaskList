import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/components/tasklist/task_list.dart';
import 'package:provider/provider.dart';

import '../../api/app_state.dart';
import '../../auth/authentication.dart';
import '../../auth/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TAREFÁCIL'),
      ),
      body: ListView(
        children: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header('Adicione suas Tarefas'),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loggedIn) ...[
                  TaskList(
                      addTask: (description, title) =>
                          appState.addToTaskBoard(title, description),
                      deleteTask: (taskId) => appState.deleteTask(taskId),
                      tasks: appState.taskListArray)
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
