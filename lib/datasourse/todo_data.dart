import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../servieces/models/taskclass.dart';

// Database class to handle Firestore operations
class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch tasks for a specific user and date
  Future<void> fetchTasks(
      String userId, Function(List<Task> tasks, int originalTaskCount) updateUI) async {
    try {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print('Fetching tasks for user: $userId and date: $todayDate'); // Add this log

      QuerySnapshot querySnapshot = await _firestore
          .collection('Tasks')
          .where('userId', isEqualTo: userId)
          .where('date', isEqualTo: todayDate)
          .get();

      List<Task> todayTasks = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Task task = Task.fromMap(data);
        task.documentId = doc.id; // Store the document ID
        return task;
      }).toList();

      print('Fetched ${todayTasks.length} tasks'); //important log
      updateUI(todayTasks, todayTasks.length);
    } on FirebaseException catch (e) {
      print('Firebase error fetching tasks: ${e.message}');
      updateUI([], 0);
    } catch (e) {
      print('General error fetching tasks: $e');
      updateUI([], 0);
    }
  }

  // Toggle the completion status of a task
  Future<bool> toggleTaskCompletion(Task task, bool newCompletionStatus) async {
    try {
      if (task.documentId == null) {
        print('Error: task.documentId is null');
        return false;
      }
      await _firestore
          .collection('Tasks')
          .doc(task.documentId)
          .update({'completed': newCompletionStatus.toString()});
      print('Task completion status toggled successfully. New status: $newCompletionStatus');
      return true;
    } on FirebaseException catch (e) {
      print('Firebase error toggling task completion: ${e.message}');
      return false;
    } catch (e) {
      print('General error toggling task completion: $e');
      return false;
    }
  }

  // Remove a task from Firestore
  Future<bool> removeTaskFromFirestore(String documentId) async {
    try {
      await _firestore.collection('Tasks').doc(documentId).delete();
      print('Task removed successfully with documentId: $documentId');
      return true;
    } on FirebaseException catch (e) {
      print('Firebase error removing task from Firestore: ${e.message}');
      return false;
    } catch (e) {
      print('General error removing task from Firestore: $e');
      return false;
    }
  }

  // Check and delete completed tasks older than one week
  Future<bool> checkAndDeleteCompletedTasks(String userId) async {
    try {
      print('Running checkAndDeleteCompletedTasks for user: $userId');
      DateTime oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
      String oneWeekAgoFormatted = DateFormat('yyyy-MM-dd').format(oneWeekAgo);

      QuerySnapshot querySnapshot = await _firestore
          .collection('Tasks')
          .where('userId', isEqualTo: userId)
          .where('completed', isEqualTo: 'true')
          .where('date', isLessThanOrEqualTo: oneWeekAgoFormatted)
          .get();

      WriteBatch batch = _firestore.batch(); // Use a batch for efficiency

      if (querySnapshot.docs.isEmpty) {
        print('No completed tasks older than one week to delete for user: $userId');
        return true; // Return true if no tasks to delete
      }

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference); // Add delete operations to the batch
        print('Deleting task with document ID: ${doc.id}');
      }

      await batch.commit(); // Commit the batch

      print('Completed tasks older than one week deleted successfully for user: $userId');
      return true;
    } on FirebaseException catch (e) {
      print('Firebase error checking and deleting completed tasks: ${e.message}');
      return false;
    } catch (e) {
      print('General error checking and deleting completed tasks: $e');
      return false;
    }
  }

  //add task
    Future<void> addTask(Task task) async {
    try {
      // Add the task data to Firestore
      DocumentReference docRef = await _firestore.collection('Tasks').add(task.toMap());
      print('Task added with document ID: ${docRef.id}');
    } on FirebaseException catch (e) {
      print("Firebase Exception at add Task ${e.message}");
      rethrow;
    } catch (e) {
      print('Error adding task to Firestore: $e');
      rethrow; // Re-throw to be caught in the UI
    }
  }
}
//user id
