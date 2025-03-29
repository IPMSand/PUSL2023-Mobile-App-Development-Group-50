// 1st code: todo_data.dart (Database Class)---this page works after adding firbase to the project
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../servieces/models/todo_taks_class.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchTasks(
      String userId, Function(List<Task> tasks, int originalTaskCount) updateUI) async {
    try {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print('Fetching tasks for user: $userId and date: $todayDate');

      QuerySnapshot querySnapshot = await _firestore
          .collection('Tasks')
          .where('userId', isEqualTo: userId)
          .where('date', isEqualTo: todayDate)
          .get();

      List<Task> todayTasks = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Task task = Task.fromMap(data);
        task.documentId = doc.id;
        return task;
      }).toList();

      print('Fetched ${todayTasks.length} tasks');
      updateUI(todayTasks, todayTasks.length);
    } on FirebaseException catch (e) {
      print('Firebase error fetching tasks: ${e.message}');
      updateUI([], 0);
    } catch (e) {
      print('General error fetching tasks: $e');
      updateUI([], 0);
    }
  }

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

      WriteBatch batch = _firestore.batch();

      if (querySnapshot.docs.isEmpty) {
        print('No completed tasks older than one week to delete for user: $userId');
        return true;
      }

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
        print('Deleting task with document ID: ${doc.id}');
      }

      await batch.commit();

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

  Future<void> addTask(Task task) async {
    try {
      DocumentReference docRef = await _firestore.collection('Tasks').add(task.toMap());
      print('Task added with document ID: ${docRef.id}');
    } on FirebaseException catch (e) {
      print("Firebase Exception at add Task ${e.message}");
      rethrow;
    } catch (e) {
      print('Error adding task to Firestore: $e');
      rethrow;
    }
  }


   // New function to fetch all tasks
  Future<void> fetchAllTasks(String userId, Function(List<Task> tasks) updateUI) async {
    try {
      print('Fetching all tasks for user: $userId');

      QuerySnapshot querySnapshot = await _firestore
          .collection('Tasks')
          .where('userId', isEqualTo: userId)
          .get();

      List<Task> allTasks = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Task task = Task.fromMap(data);
        task.documentId = doc.id;
        return task;
      }).toList();

      print('Fetched ${allTasks.length} tasks');
      updateUI(allTasks);
    } on FirebaseException catch (e) {
      print('Firebase error fetching all tasks: ${e.message}');
      updateUI([]);
    } catch (e) {
      print('General error fetching all tasks: $e');
      updateUI([]);
    }
  }
}

//user id