import 'package:flutter/material.dart';

// Assuming TodoTaskRow is defined elsewhere
class TodoTaskRow extends StatelessWidget {
  final String taskName;
  final String time;
  final String categoryName; // Added categoryName
  final bool isTaskDone;
  final VoidCallback? onTaskCompleted;

  const TodoTaskRow({
    super.key,
    required this.taskName,
    required this.categoryName, // Added categoryName
    required this.isTaskDone,
    this.onTaskCompleted,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Checkbox(
          value: isTaskDone,
          onChanged: onTaskCompleted != null
              ? (bool? value) {
                  if (value != null && value) {
                    onTaskCompleted!();
                  }
                }
              : null,
        ),
      ),
      title: Text(taskName),
      subtitle: Text(time),
      trailing: Icon(Icons.chevron_right_rounded),
      onTap: () {
        // path
      },
    );
  }
}

class TodoList extends StatelessWidget {
  final List<Task> tasks;
  final List<Task> completedTasks;
  final Function(int) onTaskCompleted;

  const TodoList({
    super.key,
    required this.tasks,
    required this.completedTasks,
    required this.onTaskCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: tasks.length + completedTasks.length,
        itemBuilder: (context, index) {
          if (index < tasks.length) {
            return TodoTaskRow(
              taskName: tasks[index].taskName,
              categoryName: tasks[index].categoryName, // Pass categoryName
              isTaskDone: tasks[index].isTaskDone,
              onTaskCompleted: () => onTaskCompleted(index), time: '',
            );
          } else {
            return TodoTaskRow(
              taskName: completedTasks[index - tasks.length].taskName,
              categoryName: completedTasks[index - tasks.length]
                  .categoryName, // Pass categoryName
              isTaskDone: true, time: '',
            );
          }
        },
      ),
    );
  }
}

// Assuming the task model is defined like this
class Task {
  final String taskName;
  final String categoryName; // Added categoryName
  final bool isTaskDone;

  Task(
      {required this.taskName,
      required this.categoryName,
      required this.isTaskDone, required String time});
}
