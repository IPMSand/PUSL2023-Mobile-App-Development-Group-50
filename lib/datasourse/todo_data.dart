import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../servieces/models/taskclass.dart';

class Database {
  Future<List<Task>> fetchTasks(
      Function(List<Task> tasks, int originalTaskCount) updateUI) async {
    try {
      String userId = 'userId'; // Replace with the actual user ID
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Cloud Firestore part
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
        updateUI([], 0); // Update UI with empty list and 0 count
        return [];
      }

      updateUI(todayTasks, todayTasks.length); // Update UI in the calling widget
      return todayTasks; // Return the tasks list
    } on FirebaseException catch (e) {
      print('Firebase error fetching tasks: ${e.message}'); // Log error
      updateUI([], 0);
      return []; // Return an empty list in case of Firebase error
    } catch (e) {
      print('General error fetching tasks: $e'); // Log error
      updateUI([], 0);
      return []; // Return an empty list in case of other errors
    }
  }



  // task done
  Future<void> toggleTaskCompletion(Task task, bool newCompletionStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Tasks')
          .doc(task.documentId!)
          .update({'completed': newCompletionStatus.toString()});
    } catch (e) {
      print('Error toggling task completion: $e'); // Log error
    }
  }




  // remove from firestore
  Future<void> removeTaskFromFirestore(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('Tasks').doc(documentId).delete();
    } catch (e) {
      print('Error removing task from Firestore: $e'); // Log error
    }
  }


  

  // check and delete done task
  Future<void> checkAndDeleteCompletedTasks() async {
    try {
      String userId = 'userId';
      DateTime oneWeekAgo = DateTime.now().subtract(Duration(days: 7)); //one week ago from now
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
    } catch (e) {
      print('Error checking and deleting completed tasks: $e'); // Log error
    }
  }
}