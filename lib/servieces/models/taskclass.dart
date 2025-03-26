
class Task {
  final String taskName;
  final String category;
  final String date; // Store date as String
  final String startTime; // Store TimeOfDay as String
  late final String completed; // Store TimeOfDay as String
  final String description;
  String? documentId; 
  String userId;// Add this line

  Task({
    required this.taskName,
    required this.category,
    required this.date,
    required this.startTime,
    required this.completed,
    required this.description,
    this.documentId,
    required this.userId,
  });

  @override
  String toString() {
    return 'Task(taskName: $taskName, category: $category, date: $date, startTime: $startTime, completed: $completed, description: $description)';
  }

  // Factory method to create a Task object from a Map (Firestore data)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskName: map['taskName'] ?? '',
      category: map['category'] ?? '',
      date: map['date'] ?? '',
      startTime: map['startTime'] ?? '',
      completed: map['completed'] ?? 'false',
      description: map['description'] ?? '',
       documentId: null, userId: '', // Initialize documentId to null
    );
  }

  // Method to convert Task object to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'category': category,
      'date': date,
      'startTime': startTime,
      'completed': completed,
      'description': description,
    };
  }
}
/* Models - data models or classes */