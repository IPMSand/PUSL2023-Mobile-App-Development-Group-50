class Task {
  final String taskName;
  final String category;
  final String date; // Store date as String
  final String startTime; // Store TimeOfDay as String
  final String endTime; // Store TimeOfDay as String
  late final String completed;
  final String description;
  String? documentId;
  String userId;

  Task({
    required this.taskName,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime, // Add this line
    required this.completed,
    required this.description,
    this.documentId,
    required this.userId,
  });

  @override
  String toString() {
    return 'Task(taskName: $taskName, category: $category, date: $date, startTime: $startTime, endTime: $endTime, completed: $completed, description: $description)';
  }

  // Factory method to create a Task object from a Map (Firestore data)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskName: map['taskName'] ?? '',
      category: map['category'] ?? '',
      date: map['date'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '', // Add this line
      completed: map['completed'] ?? 'false',
      description: map['description'] ?? '',
      documentId: null,
      userId: '',
    );
  }

  // Method to convert Task object to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'category': category,
      'date': date,
      'startTime': startTime,
      'endTime': endTime, // Add this line
      'completed': completed,
      'description': description,
    };
  }
}
/* Models - data models or classes */
/* Models - data models or classes */