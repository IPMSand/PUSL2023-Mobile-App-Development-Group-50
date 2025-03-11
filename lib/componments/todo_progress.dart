import 'package:flutter/material.dart';
import 'package:mad_project/screens/task_home_page.dart';

class ProgressSummary extends StatelessWidget {
  final List<Task> tasks;
  final double progress;

  const ProgressSummary({super.key, required this.tasks, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today\'s progress Summary', style: TextStyle(fontSize: 18)),
                  Text('${tasks.length} tasks', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text('progress ${progress * 100}%'),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(value: progress),
      ],
    );
  }
}











/*
class ProgressDetails extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const ProgressDetails({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
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
                      const SizedBox(width: 8),
                      Text(
                        '${(progressPercentage * 100).toStringAsFixed(0)}%',
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
}*/