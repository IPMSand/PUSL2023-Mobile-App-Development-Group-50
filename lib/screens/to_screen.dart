import 'package:flutter/material.dart';
// import '../screens/to_create.dart';
import '../componments/todo_img.dart';
import '../componments/todo_list.dart';
import '../componments/todo_midtitle.dart';
import '../componments/todo_taskbtn.dart';
import '../componments/todo_toptitle.dart';


// To-Do List Screen (in todo_screen.dart)
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoState();
}

class _TodoState extends State<TodoScreen> {
  final List<Task> _tasks = [
    Task(taskName: 'task 1',categoryName: 'html', isTaskDone: false),
    Task(taskName: 'task 2',categoryName: 'css', isTaskDone: false),
    Task(taskName: 'task 3',categoryName: 'data', isTaskDone: false),
    Task(taskName: 'task 4',categoryName: 'html', isTaskDone: false),
    Task(taskName: 'task 5',categoryName: 'html', isTaskDone: false),
  ];

  final List<Task> _completedTasks = [];

  void _onTaskCompleted(int index) {
    setState(() {
      final task = _tasks[index];
      _tasks.removeAt(index);
      _completedTasks.add(task);
    });
  }

void _addNewTask(String taskName, String categoryName, [bool? bool]) {
  setState(() {
    _completedTasks.add(Task(taskName: taskName, categoryName: categoryName, isTaskDone: false));
  });
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("To Do List"),
          backgroundColor: Colors.greenAccent,
        ),
        body: _todoBody(),
      ),
    );
  }

  // to do body
  Widget _todoBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          // ttitle
          TopTitle(),

          // img
          TodoImage(),

          

          // list links
          Align(
            child: TodoTileHeader(
              date: '24 Feb 2025', // Replace with your desired date
              onViewAllPressed: () {
                // Add your logic to view all tasks here
               debugPrint('View All Tasks pressed!');
              },
            ),
          ),

          // list here
          Expanded(
            child: TodoList(
              tasks: _tasks,
              completedTasks: _completedTasks,
              onTaskCompleted: _onTaskCompleted,
            ),
          ),

          // button
          TodoCreateButton(
            onPressed: () {
              // Add your logic to create a new todo here
              //(_tasks).add(Task(taskName: 'did 45',categoryName: 'html', isTaskDone: false));
             
             _addNewTask("Write report", "Work", false);
              
              debugPrint('Create todo button pressed!');
            },
            icon: Icons.add, // Optional: Change the icon
          ),

          // size box
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}