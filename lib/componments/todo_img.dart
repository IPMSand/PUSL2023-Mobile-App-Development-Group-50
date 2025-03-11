import 'package:flutter/material.dart';

// Component: _TodoImage.dart (Note the underscore)
class TodoImage extends StatelessWidget {
  const TodoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/img11.png',
        width: 120,
      ),
    );
  }
}






/* here original
  Widget _todoImg() {
    return Center(
      child: Image.asset(
        'assets/img11.png',
        width: 120,
      ),
    );
  }
  */
  /*
  
  
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

  // to do image..here
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
    int totalTasks = _tasks.length + _completedTasks.length;
    int completedTasks = _completedTasks.length; // Example completed tasks

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

  Widget _todoTile2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'TODAY',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('23 Feb 2025'),
            ),
            TextButton(onPressed: () {}, child: const Text('View All Tasks')),
          ],
        ),
      ],
    );
  }

  // todo list
  Widget _todoList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _tasks.length + _completedTasks.length,
        itemBuilder: (context, index) {
          if (index < _tasks.length) {
            return TodoTaskRow(
              taskName: _tasks[index].taskName,
              isTaskDone: _tasks[index].isTaskDone,
              onTaskCompleted: () => _onTaskCompleted(index),
            );
          } else {
            return TodoTaskRow(
              taskName: _completedTasks[index - _tasks.length].taskName,
              isTaskDone: true,
            );
          }
        },
      ),
    );
  }

  Widget _todoCreateButton() {
    return ElevatedButton(onPressed: () {}, child: const Icon(Icons.add));
  } */