import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../servieces/models/taskclass.dart';

class Database {
  Future<List<Task>> fetchTasks(
      String userId, // User ID as parameter
      Function(List<Task> tasks, int originalTaskCount) updateUI) async {
    try {
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
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

      if (todayTasks.isEmpty) {
        updateUI([], 0);
        return [];
      }

      updateUI(todayTasks, todayTasks.length);
      return todayTasks;
    } on FirebaseException catch (e) {
      print('Firebase error fetching tasks: ${e.message}');
      updateUI([], 0);
      return [];
    } catch (e) {
      print('General error fetching tasks: $e');
      updateUI([], 0);
      return [];
    }
  }

  Future<bool> toggleTaskCompletion(Task task, bool newCompletionStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Tasks')
          .doc(task.documentId!)
          .update({'completed': newCompletionStatus.toString()});
      return true; // Return success
    } catch (e) {
      print('Error toggling task completion: $e');
      return false; // Return failure
    }
  }

  Future<bool> removeTaskFromFirestore(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('Tasks').doc(documentId).delete();
      return true;
    } catch (e) {
      print('Error removing task from Firestore: $e');
      return false;
    }
  }

  Future<bool> checkAndDeleteCompletedTasks(String userId) async { //userID as Parameter
    try {
      DateTime oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
      String oneWeekAgoFormatted = DateFormat('yyyy-MM-dd').format(oneWeekAgo);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Tasks')
          .where('userId', isEqualTo: userId)
          .where('completed', isEqualTo: 'true')
          .where('date', isLessThanOrEqualTo: oneWeekAgoFormatted)
          .get();

      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
      return true;
    } catch (e) {
      print('Error checking and deleting completed tasks: $e');
      return false;
    }
  }
}