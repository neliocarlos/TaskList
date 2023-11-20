import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtk_flutter/src/components/tasklist/task_list.dart';
import 'package:provider/provider.dart';

import '../../api/app_state.dart';
import '../../auth/authentication.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void toggleLogin(BuildContext context, ApplicationState appState) {
    if (appState.loggedIn) {
      appState.logOut();
    } else {
      context.push('/sign-in');
    }
  }

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
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loggedIn) ...[
                  TaskList(
                      addTask: (date, title, color) =>
                          appState.addToTaskBoard(title, date, color),
                      updateTask: (taskId, newTitle, newDate, newColor) =>
                          appState.updateTask(
                              taskId, newDate, newTitle, newColor),
                      deleteTask: (taskId) => appState.deleteTask(taskId),
                      tasks: appState.taskListArray)
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.blue.shade600,
              ),
              label: 'Página Inicial',
              backgroundColor: Color.fromARGB(255, 44, 92, 196)),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            label: 'Sair',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            GoRouter.of(context).go('/profile');
          } else if (index == 2) {
            toggleLogin(
                context, Provider.of<ApplicationState>(context, listen: false));
            context.push('/sign-in');
          }
        },
      ),
    );
  }
}
