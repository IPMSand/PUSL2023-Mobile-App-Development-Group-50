import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:intl/intl.dart';
import '../models/todo_taks_class.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // for view now page
  Future<void> fetchTasks(String userId,
      Function(List<Task> tasks, int originalTaskCount) updateUI) async {
    try {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      debugPrint('Fetching tasks for user: $userId and date: $todayDate');

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

      debugPrint('Fetched ${todayTasks.length} tasks');
      updateUI(todayTasks, todayTasks.length);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error fetching tasks: ${e.message}');
      updateUI([], 0);
    } catch (e) {
      debugPrint('General error fetching tasks: $e');
      updateUI([], 0);
    }
  }

  // for view now page
  Future<bool> toggleTaskCompletion(Task task, bool newCompletionStatus) async {
    try {
      if (task.documentId == null) {
        debugPrint('Error: task.documentId is null');
        return false;
      }
      await _firestore
          .collection('Tasks')
          .doc(task.documentId)
          .update({'completed': newCompletionStatus.toString()});
      debugPrint(
          'Task completion status toggled successfully. New status: $newCompletionStatus');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('Firebase error toggling task completion: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('General error toggling task completion: $e');
      return false;
    }
  }

  // for view now page
  Future<bool> removeTaskFromFirestore(String documentId) async {
    try {
      await _firestore.collection('Tasks').doc(documentId).delete();
      debugPrint('Task removed successfully with documentId: $documentId');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('Firebase error removing task from Firestore: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('General error removing task from Firestore: $e');
      return false;
    }
  }

  // for viewnow page
  Future<bool> checkAndDeleteCompletedTasks(String userId) async {
    try {
      debugPrint('Running checkAndDeleteCompletedTasks for user: $userId');
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
        debugPrint(
            'No completed tasks older than one week to delete for user: $userId');
        return true;
      }

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
        debugPrint('Deleting task with document ID: ${doc.id}');
      }

      await batch.commit();

      debugPrint(
          'Completed tasks older than one week deleted successfully for user: $userId');
      return true;
    } on FirebaseException catch (e) {
      debugPrint(
          'Firebase error checking and deleting completed tasks: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('General error checking and deleting completed tasks: $e');
      return false;
    }
  }

  // for add task sccreen
  Future<void> addTask(Task task) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('Tasks').add(task.toMap());
      debugPrint('Task added with document ID: ${docRef.id}');
    } on FirebaseException catch (e) {
      debugPrint("Firebase Exception at add Task ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint('Error adding task to Firestore: $e');
      rethrow;
    }
  }

  // New function to fetch all tasks for allview task screen
  Future<void> fetchAllTasks(
      String userId, Function(List<Task> tasks) updateUI) async {
    try {
      debugPrint('Fetching all tasks for user: $userId');

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

      debugPrint('Fetched ${allTasks.length} tasks');
      updateUI(allTasks);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error fetching all tasks: ${e.message}');
      updateUI([]);
    } catch (e) {
      debugPrint('General error fetching all tasks: $e');
      updateUI([]);
    }
  }
}

//user id
