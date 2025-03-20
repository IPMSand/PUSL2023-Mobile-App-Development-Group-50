import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';
import '../screens/todo_create_screen.dart';
import '../servieces/models/taskclass.dart';

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
    Task(name: 'HTML', time: '09.00 AM - 11.00 AM', completed: false),
    Task(name: 'CSS', time: '11.30 AM - 01.30 PM', completed: false),
    Task(name: 'PHP', time: '2.00 PM - 04.00 PM', completed: false),
    Task(name: 'QUIZ', time: '04.30 PM - 05.30 PM', completed: false),
  ];

  List<Task> completedTasks = []; // List to store completed tasks --- later show in BtN(See All);
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
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            // top title
            _topTitle(),

            // img
            _todoImg(),

            // progress section
            _todoProgress(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // list title
                _todoListTitle(),

                // see all button _viewAll(),
              ],
            ),
            // todo tasks list
            _todoTaskList(),

            // task buton
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

  //widgets inside the body----
  _topTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text('My To-Do ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          )),
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
      // Container for progress related items
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
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
              backgroundColor:
                  Colors.grey[300], // Intial color
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue), // After progress
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
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        )),
    );
  }

  /*_viewAll() {
    return TextButton(
        onPressed: () {
          debugPrint('Clicked! see all');
        },
        child: Text('See All'));
  }--- no pages to view*/

  _todoTaskList() {
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            surfaceTintColor: const Color.fromARGB(255, 112, 191, 137),
            child: ListTile(
              leading: Checkbox(
                value: tasks[index].completed,
                onChanged: (bool? value) => _toggleTaskCompletion(index),
              ),
              title: Text(tasks[index].name),
              subtitle: Text(tasks[index].time),
              trailing: InkWell(
                onTap: () {
                  debugPrint('Clikied List Trailing!!');
                },
                child: Icon(Icons.chevron_right),
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
        );
      },
      child: Icon(Icons.add),
    );
  }

  // bottom nav bar
}

