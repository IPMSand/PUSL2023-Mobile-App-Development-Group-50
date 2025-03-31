// view all the tasks screen
import 'package:flutter/material.dart';
import '../models/todo_taks_class.dart';
import '../database/todo_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  _AllTasksScreenState createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  List<Task> tasks = [];
  final Database _database = Database();
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          currentUserId = user.uid;
        });
         debugPrint('Current User ID (initState): $currentUserId');
        _fetchTasks();
      } else {
        debugPrint('User is currently signed out!');
      }
    }, onError: (error) {
       debugPrint('Error listening to auth state: $error');
      _showSnackBar('Error listening to authentication status.');
    });
  }

  void _updateUI(List<Task> fetchedTasks) {
    setState(() {
      tasks = fetchedTasks;
    });
  }

  Future<void> _fetchTasks() async {
    if (currentUserId.isNotEmpty) {
      try {
        await _database.fetchAllTasks(currentUserId, _updateUI);
      } catch (e) {
         debugPrint('Error fetching tasks: $e');
        _showSnackBar('Failed to fetch tasks.');
      }
    }
  }

  Future<void> _toggleTaskCompletion(int index) async {
    try {
      Task task = tasks[index];
      bool newCompletionStatus = task.completed == 'true' ? false : true;

      bool success = await _database.toggleTaskCompletion(task, newCompletionStatus);

      if (success) {
        _fetchTasks();
      } else {
        _showSnackBar('Failed to toggle task completion.');
      }
    } catch (e) {
       debugPrint('Error toggling task completion in UI: $e');
      _showSnackBar('Error toggling task completion.');
    }
  }

  Future<void> _removeTaskFromFirestore(String documentId) async {
    try {
      bool removeSuccess = await _database.removeTaskFromFirestore(documentId);
      if (removeSuccess) {
        _fetchTasks();
      } else {
        _showSnackBar('Failed to remove task.');
      }
    } catch (e) {
       debugPrint('Error removing task from Firestore in UI: $e');
      _showSnackBar('Error removing task.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Task>> tasksByCategory = {};
    for (var task in tasks) {
      if (tasksByCategory.containsKey(task.category)) {
        tasksByCategory[task.category!]!.add(task);
      } else {
        tasksByCategory[task.category!] = [task];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My All Tasks'),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView.builder(
        itemCount: tasksByCategory.length,
        itemBuilder: (context, categoryIndex) {
          String category = tasksByCategory.keys.toList()[categoryIndex];
          List<Task> categoryTasks = tasksByCategory[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categoryTasks.length,
                itemBuilder: (context, taskIndex) {
                  Task task = categoryTasks[taskIndex];
                  return Card(
                    surfaceTintColor: const Color.fromARGB(255, 112, 191, 137),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.completed == 'true',
                        onChanged: (bool? value) =>
                            _toggleTaskCompletion(tasks.indexOf(task)),
                      ),
                      title: Text(
                        task.taskName,
                        style: task.completed == 'true'
                            ? TextStyle(decoration: TextDecoration.lineThrough)
                            : null,
                      ),
                      subtitle: Text('Date: ${task.date ?? ''}'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(task.taskName),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Date: ${task.date ?? ''}'),
                                    Text('Start: ${task.startTime ?? ''}'),
                                    Text('End: ${task.endTime ?? ''}'),
                                    Text('Category: ${task.category ?? ''}'),
                                    Text('Description: ${task.description ?? ''}'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      trailing: InkWell(
                        onTap: () {
                          _removeTaskFromFirestore(task.documentId!);
                        },
                        child: Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}