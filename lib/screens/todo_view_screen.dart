import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';
import '../screens/todo_create_screen.dart';
import '../servieces/models/taskclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  List<Task> completedTasks = [];
  late int originalTaskCount;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _checkAndDeleteCompletedTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      String userId = 'userId';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Tasks')
          .where('userId', isEqualTo: userId)
          .get();

      List<Task> fetchedTasks = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Task task = Task.fromMap(data);
        task.documentId = doc.id; // Store the document ID
        return task;
      }).toList();

      setState(() {
        tasks = fetchedTasks
            .where((task) =>
                task.date == DateFormat('yyyy-MM-dd').format(DateTime.now()))
            .toList();
        originalTaskCount = tasks.length;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  double get progress {
    if (originalTaskCount == 0) return 0.0;
    return completedTasks.length / originalTaskCount;
  }

Future<void> _toggleTaskCompletion(int index) async {
    try {
        Task task = tasks[index];
        bool newCompletionStatus = task.completed == 'true' ? false : true;

        // Update Firestore
        await FirebaseFirestore.instance
            .collection('Tasks')
            .doc(task.documentId!)
            .update({'completed': newCompletionStatus.toString()});

        if (newCompletionStatus) {
            // Add to completedTasks list
            setState(() {
                completedTasks.add(task);
                tasks.removeAt(index);
            });
        } else {
            // Refresh the task list from Firestore
            await _fetchTasks();
        }

    } catch (e) {
        print('Error toggling task completion: $e');
    }
}

  Future<void> _removeTaskFromFirestore(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('Tasks').doc(documentId).delete();
    } catch (e) {
      print('Error removing task from Firestore: $e');
    }
  }

  Future<void> _checkAndDeleteCompletedTasks() async {
    try {
      String userId = 'userId';
      DateTime oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
      String oneWeekAgoFormatted = DateFormat('yyyy-MM-dd').format(oneWeekAgo);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Tasks')
          .where('userId', isEqualTo: userId)
          .where('completed', isEqualTo: 'true')
          .where('date', isLessThanOrEqualTo: oneWeekAgoFormatted)
          .get();

      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    } catch (e) {
      print('Error checking and deleting completed tasks: $e');
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
                        title: Text(tasks[index].taskName),
                        subtitle: Text(tasks[index].startTime),
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
        ).then((value) => _fetchTasks());
      },
      child: Icon(Icons.add),
    );
  }
}
