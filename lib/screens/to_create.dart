import 'package:flutter/material.dart';

// TodoTaskRow widget (in todo_taskfiled.dart)
class TodoTaskRow extends StatefulWidget {
  final String taskName;
  final bool isTaskDone;
  final VoidCallback? onTaskCompleted; // Add this line

  const TodoTaskRow({
    super.key,
    required this.taskName,
    required this.isTaskDone,
    this.onTaskCompleted, // Add this line
  });

  @override
  State<TodoTaskRow> createState() => _TodoTaskRowState();
}

class _TodoTaskRowState extends State<TodoTaskRow> {
  bool _taskDone = false;

  @override
  void initState() {
    super.initState();
    _taskDone = widget.isTaskDone;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(2), right: Radius.circular(2)),
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(255, 255, 255, 255))),
      ),
      child: CheckboxListTile(
        title: Text(widget.taskName),
        value: _taskDone,
        onChanged: (bool? newValue) {
          if (newValue != null) {
            setState(() {
              _taskDone = newValue;
              if (_taskDone && widget.onTaskCompleted != null) {
                widget.onTaskCompleted!();
              }
            });
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}