import 'package:flutter/material.dart';
import 'package:mad_project/widgets/colored_bottom_nav.dart';
import '../screens/allview_todo.dart';
import '../screens/add_todo.dart';
import '../models/todo_taks_class.dart';
import '../database/todo_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  List<Task> completedTasks = [];
  int originalTaskCount = 0;
  final Database _database = Database();
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _checkAndDeleteCompletedTasks();
  }

  Future<void> _fetchCurrentUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          currentUserId = user.uid;
        });
        print('Current User ID (initState): $currentUserId');
        _fetchTasks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in. Please log in.')),
        );
      }
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user. Please check your connection.')),
      );
    });
  }

  void _updateUI(List<Task> fetchedTasks, int taskCount) {
    setState(() {
      tasks = fetchedTasks;
      originalTaskCount = taskCount;
    });
  }

  Future<void> _fetchTasks() async {
    if (currentUserId.isNotEmpty) {
      try {
        await _database.fetchTasks(currentUserId, _updateUI);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load tasks. Please try again.')),
        );
      }
    }
  }

  double get progress {
    if (originalTaskCount == 0) return 0.0;
    completedTasks = tasks.where((task) => task.completed == 'true').toList();
    return completedTasks.length / originalTaskCount;
  }

  Future<void> _toggleTaskCompletion(int index) async {
    try {
      Task task = tasks[index];
      bool newCompletionStatus = task.completed == 'true' ? false : true;

      bool success = await _database.toggleTaskCompletion(task, newCompletionStatus);

      if (success) {
        _fetchTasks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update task status. Please try again.')),
        );
      }
    } catch (e) {
      print('Error toggling task completion in UI: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
    }
  }

  Future<void> _removeTaskFromFirestore(String documentId) async {
    try {
      bool removeSuccess = await _database.removeTaskFromFirestore(documentId);
      if (removeSuccess) {
        _fetchTasks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove task. Please try again.')),
        );
      }
    } catch (e) {
      print('Error removing task from Firestore in UI: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
    }
  }

  Future<void> _checkAndDeleteCompletedTasks() async {
    try {
      if (currentUserId.isNotEmpty) {
        bool deleteSuccess = await _database.checkAndDeleteCompletedTasks(currentUserId);
        if (!deleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to manage completed tasks. Please try again.')),
          );
        }
      }
    } catch (e) {
      print('Error checking and deleting completed tasks in UI: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
    }
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My To-Do Tasks'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _topTitle(),
            _todoImg(),
            _todoProgress(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _todoListTitle(),
                _viewAll(),
              ],
            ),
            _todoTaskList(),
            _todoTaskAddBtn(),
          ],
        ),
      ),
      bottomNavigationBar: ColoredBottomBar(),
    );
  }

  _topTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text('My Day ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  _todoImg() {
    return Center(
      child: Image.asset(
        'assets/images/start3.png',
        height: 120,
      ),
    );
  }

  _todoProgress() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 73, 175, 137),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Today\'s progress Summary',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('$originalTaskCount tasks',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 55, 55, 55))),
                  ],
                ),
              ),
              Text('progress ${(progress * 100).toStringAsFixed(2)}%'),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  _todoListTitle() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text('Today\'s Tasks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  _viewAll() {
    return TextButton(
      onPressed: () {
        debugPrint('Clicked! see all');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllTasksScreen()),
        );
      },
      child: Text('See All'),
    );
  }


  _todoTaskList() {
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            surfaceTintColor: const Color.fromARGB(255, 112, 191, 137),
                   child: ListTile(
            leading: Checkbox(
            value: tasks[index].completed == 'true',
            onChanged: (bool? value) => _toggleTaskCompletion(index),
            ),
          title: Text(
            tasks[index].taskName,
            style: TextStyle(
            fontWeight: FontWeight.bold,
            color: tasks[index].completed == 'true' ? Colors.grey : const Color.fromARGB(255, 124, 11, 122), 
            decoration: tasks[index].completed == 'true' ? TextDecoration.lineThrough : null,
            ),
          ),
           subtitle: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              Row( 
                children: [
                   Text('Start: ${tasks[index].startTime ?? ''}'),
                   SizedBox(width: 10), 
                   Text('End: ${tasks[index].endTime ?? ''}'),
                 ],
              ),
         ],
        ),
       onTap: () {
         showDialog(
           context: context,
           builder: (BuildContext context) {
              return AlertDialog(
              title: Text(tasks[index].taskName),
              content: SingleChildScrollView(
               child: ListBody(
                   children: <Widget>[
                  Text('Date: ${tasks[index].date ?? ''}'),
                  Text('Category: ${tasks[index].category ?? ''}'),
                  Text('Description: ${tasks[index].description ?? ''}'),
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
),
           
          );
        },
      ),
    );
  }

  _todoTaskAddBtn() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateTaskScreen()),
        ).then((value) => _fetchTasks());
      },
      child: Icon(Icons.add),
    );
  }
}
// user id,
