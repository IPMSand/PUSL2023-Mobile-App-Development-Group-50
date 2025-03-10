import 'package:flutter/material.dart';

// To-Do List Screen
class TodoScreen extends StatefulWidget {
  final dynamic controllarFor; // what is dynamic , what happnes withouth it?
  final String taskName;

  const TodoScreen(
      {super.key, required this.taskName, required this.controllarFor});

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

          // task name
          _taskName(),

          // task category
          _taskCategory(),

          // task due date
          _taskDueDate(),

          // task due time
          _taskDueTime(),

          // task description
          _taskDescription(),

          // add task button
          _taskSave(),
        ],
      ),
    );
  }

  // functions --later for
  // ttitle
  _topTitle() {
    return Text('Craete a new task');
  }

  // task name
  _taskName() {
    return TextField(
      style: const TextStyle(color: Color.fromARGB(255, 1, 0, 0), fontSize: 20),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(67, 255, 255, 255), width: 3.0),
        borderRadius: BorderRadius.circular(12.0),
      )),
    );
  }

  // task category
  _taskCategory() {}

  // task due date
  _taskDueDate() {}

  // task due time
  _taskDueTime() {}

  // task description
  _taskDescription() {}

  // add task button
  _taskSave() {}
}
