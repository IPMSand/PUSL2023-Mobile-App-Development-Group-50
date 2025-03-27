import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/bottom_navbar.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int _selectedIndex = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveEvent() async {
    String title = titleController.text.trim();
    String note = noteController.text.trim();
    Timestamp date = Timestamp.fromDate(selectedDate);

    if (title.isEmpty || note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter title and note')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('events').add({
        'title': title,
        'note': note,
        'date': date,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event saved successfully')),
      );

      // Clear fields after saving
      titleController.clear();
      noteController.clear();
      setState(() {
        selectedDate = DateTime.now();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Event'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.asset('assets/images/start5.png', height: 150),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade700]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  Icon(Icons.shield, color: Colors.black),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text('Date & Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
            ),
            SizedBox(height: 10),
            Align(alignment: Alignment.centerLeft, child: Text('Title', style: TextStyle(color: Colors.blue))),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 10),
            Align(alignment: Alignment.centerLeft, child: Text('Note', style: TextStyle(color: Colors.blue))),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveEvent,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBarWidget(
        initialIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}