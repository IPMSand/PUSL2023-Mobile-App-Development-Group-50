
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addTask(Map<String, dynamic> studentInfo, String id) async {
try {
return await FirebaseFirestore.instance
.collection("Students")
.doc(id)
.set(studentInfo);
} catch (e) {
print('Error: $e');
}
}
