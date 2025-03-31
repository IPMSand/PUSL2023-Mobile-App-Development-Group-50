
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventDatabase {
  Future<Map<DateTime, List<String>>> loadEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    final Map<DateTime, List<String>> events = {};
    if (user != null) {
      final eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (var doc in eventsSnapshot.docs) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        final title = data['title'];
        final note = data['note'];
        final startTime = data['startTime'];

        String eventText = '$title - $note';
        if (startTime != null) {
          eventText = '$startTime - $title : $note';
        }

        final dateTimeKey = DateTime(date.year, date.month, date.day);
        if (events[dateTimeKey] == null) {
          events[dateTimeKey] = [];
        }
        events[dateTimeKey]!.add(eventText.toUpperCase());
      }
    }
    return events;
  }
}