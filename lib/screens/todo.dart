import 'package:flutter/material.dart';
import 'package:mad_project/componments/todo_taskfiled.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// To-Do List Screen
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoState();
}

class _TodoState extends State<TodoScreen> {
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
          _topTitle(),
          // img
          _todoImg(),

          // progress
          _progressDetails(),

          // list links
          _todoTile2(),

          // list here
          Expanded(
              child:
                  _todoList()), // Expanded to allow list to take remaining space
          // button
          _todoCreateButton(),
          // size box
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _topTitle() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'TO DO',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _todoImg() {
    return Center(
      child: Image.asset(
        'assets/img11.png',
        width: 120,
      ),
    );
  }

  Widget _progressDetails() {
    // Example data (replace with your actual task count and completed tasks)
    int totalTasks = 15;
    int completedTasks = 5; // Example completed tasks

    // Calculate the percentage
    double progressPercentage =
        totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14),
      height: 80,
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 58, 173, 102),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          const Text(
            'Today Progress',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$totalTasks Tasks',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                children: [
                  const Text(
                    'Progress here',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      LinearPercentIndicator(
                        width: 70.0,
                        lineHeight: 14.0,
                        percent: progressPercentage,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.blue,
                      ),
                      const SizedBox(width: 8), // Add some spacing
                      Text(
                        '${(progressPercentage * 100).toStringAsFixed(0)}%', // Display the percentage
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ++++
  _todoTile2() {
    Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'TODAY',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('23 Feb 2025'),
        ),
        TextButton(onPressed: () {}, child: Text('View All Tasks')),
      ],
    );
  }

  // todo list
  Widget _todoList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: const <Widget>[
          TodoTaskRow(
            taskName: 'task 1',
            isTaskDone: false,
          ),
          TodoTaskRow(
            taskName: 'task 2',
            isTaskDone: false,
          ),
          TodoTaskRow(
            taskName: 'task 3',
            isTaskDone: false,
          ),
          TodoTaskRow(
            taskName: 'task 3',
            isTaskDone: false,
          ),
          TodoTaskRow(
            taskName: 'task 3',
            isTaskDone: false,
          ),
        ],
      ),
    );
  }

  Widget _todoCreateButton() {
    return ElevatedButton(onPressed: () {}, child: Icon(Icons.add));
  }
}
