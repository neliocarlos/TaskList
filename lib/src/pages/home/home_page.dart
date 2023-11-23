import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtk_flutter/src/components/tasklist/task_list.dart';
import 'package:provider/provider.dart';

import '../../api/app_state.dart';
import '../../auth/authentication.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

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
              },
            ),
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
                    addTask: (date, title, color, initialTime, finalTime) =>
                        appState.addToTaskBoard(
                            title, date, color, initialTime, finalTime),
                    updateTask: (taskId, newTitle, newDate, newColor,
                            newInitialTime, newFinalTime) =>
                        appState.updateTask(taskId, newDate, newTitle, newColor,
                            newInitialTime, newFinalTime),
                    deleteTask: (taskId) => appState.deleteTask(taskId),
                    tasks: appState.taskListArray,
                  ),
                ],
                if (!appState.loggedIn) ...[
                  Center(
                    heightFactor: 16,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign-in');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Valor alto para tornar o botão redondo
                        ), // Cor do texto branco
                      ),
                      child: Text(
                        'Faça login',
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: Provider.of<ApplicationState>(context).loggedIn,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.blue.shade600,
              ),
              label: 'Página Inicial',
              backgroundColor: Color.fromARGB(255, 44, 92, 196),
            ),
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
                context,
                Provider.of<ApplicationState>(context, listen: false),
              );
              context.push('/sign-in');
            }
          },
        ),
      ),
    );
  }
}
