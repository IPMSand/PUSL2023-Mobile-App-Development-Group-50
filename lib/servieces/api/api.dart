/*Future<void> addStudent(Map<String, dynamic> studentInfo, String id) async {
try {
return await FirebaseFirestore.instance
.collection("Students")
.doc(id)
.set(studentInfo);
} catch (e) {
print('Error: $e');
}
}
*/