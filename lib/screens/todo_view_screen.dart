import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';
import '../screens/todo_create_screen.dart';
import '../servieces/models/taskclass.dart';
import 'package:intl/intl.dart';
import '../datasourse/todo_data.dart'; // Import the new Database class

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
  String currentUserId = 'actualUserId'; // Replace with actual user ID

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _checkAndDeleteCompletedTasks();
  }

  void _updateUI(List<Task> fetchedTasks, int taskCount) {
    setState(() {
      tasks = fetchedTasks;
      originalTaskCount = taskCount;
    });
  }

  Future<void> _fetchTasks() async {
    await _database.fetchTasks(currentUserId, _updateUI);
  }

  double get progress {
    if (originalTaskCount == 0) return 0.0;
    return completedTasks.length / originalTaskCount;
  }

  Future<void> _toggleTaskCompletion(int index) async {
    try {
      Task task = tasks[index];
      bool newCompletionStatus = task.completed == 'true' ? false : true;

      bool success = await _database.toggleTaskCompletion(task, newCompletionStatus);

      if (success) {
        List<Task> fetchedTasks = await _database.fetchTasks(currentUserId, (fetched, count) {});
        setState(() {
          tasks = fetchedTasks;
          tasks.sort((a, b) {
            if (a.completed == 'true' && b.completed == 'false') {
              return 1;
            } else if (a.completed == 'false' && b.completed == 'true') {
              return -1;
            } else {
              return 0;
            }
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to toggle task completion.')),
        );
      }
    } catch (e) {
      print('Error toggling task completion in UI: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error toggling task completion.')),
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
          SnackBar(content: Text('Failed to remove task.')),
        );
      }
    } catch (e) {
      print('Error removing task from Firestore in UI: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing task.')),
      );
    }
  }

  Future<void> _checkAndDeleteCompletedTasks() async {
    try {
      bool deleteSuccess = await _database.checkAndDeleteCompletedTasks(currentUserId);
      if (!deleteSuccess){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to manage completed tasks.')),
        );
      }
    } catch (e) {
      print('Error checking and deleting completed tasks in UI: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error managing completed tasks.')),
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
        title: Text('To Do List'),
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
              ],
            ),
            _todoTaskList(),
            _todoTaskAddBtn(),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBarWidget(
        initialIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  _topTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text('My To-Do ',
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
        color: const Color.fromARGB(255, 73, 175, 131),
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
                style: tasks[index].completed == 'true'
                    ? TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              subtitle: Text(tasks[index].startTime),
              trailing: InkWell(
                onTap: () {
                  _removeTaskFromFirestore(tasks[index].documentId!);
                },
                child: Icon(Icons.delete),
              ),
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
// user id