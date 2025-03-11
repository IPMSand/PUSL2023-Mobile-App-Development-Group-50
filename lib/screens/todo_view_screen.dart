import 'package:flutter/material.dart';
import 'package:mad_project/screens/todo_create_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [
    Task(name: 'HTML', time: '09.00 AM - 11.00 AM', completed: false),
    Task(name: 'CSS', time: '11.30 AM - 01.30 PM', completed: false),
    Task(name: 'PHP', time: '2.00 PM - 04.00 PM', completed: false),
    Task(name: 'QUIZ', time: '04.30 PM - 05.30 PM', completed: false),
  ];

  List<Task> completedTasks = []; // List to store completed tasks
  late int originalTaskCount; // Store the original task count

  @override
  void initState() {
    super.initState();
    originalTaskCount = tasks.length; // Initialize original task count
  }

  double get progress {
    if (originalTaskCount == 0) return 0.0;
    return completedTasks.length / originalTaskCount;
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
      if (tasks[index].completed) {
        completedTasks.add(tasks[index]); // Add to completed tasks list
        tasks.removeAt(index); // Remove from the original list
      }
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
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Welcome',
             style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              )),
            SizedBox(height: 50),
            // img
            Center(child: Image.asset('assets/img11.png', height: 120,),),
            SizedBox(height: 20),
            Container( // Container for progress related items
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 129, 191, 161), // Background color of the container
                borderRadius: BorderRadius.circular(10),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  )),
                            Text('$originalTaskCount tasks',
                                style: TextStyle(color: const Color.fromARGB(255, 55, 55, 55))),
                          ],
                        ),
                      ),
                      Text('progress ${(progress * 100).toStringAsFixed(2)}%'),
                    ],
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300], // Background color of the progress bar
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Color of the progress bar
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Today\'s Task', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: tasks[index].completed,
                      onChanged: (bool? value) => _toggleTaskCompletion(index),
                    ),
                    title: Text(tasks[index].name),
                    subtitle: Text(tasks[index].time),
                    trailing: Icon(Icons.chevron_right),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Task {
  String name;
  String time;
  bool completed;

  Task({required this.name, required this.time, this.completed = false});
}