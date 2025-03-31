import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventDatabase {
  Future<void> saveEvent(String title, String note, DateTime date, String startTime) async{
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    Timestamp timeStampDate = Timestamp.fromDate(date);

    await FirebaseFirestore.instance.collection('events').add({
      'userId': userId,
      'title': title,
      'note': note,
      'date': timeStampDate,
      'startTime': startTime,
      'createdAt': Timestamp.now(),
    });
  }
}