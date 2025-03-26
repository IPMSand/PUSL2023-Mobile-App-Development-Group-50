import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import '../widgets/bottom_navbar.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  String _category = 'Programming Language';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();
  final List<String> _categories = [
    'Programming Language',
    'Assignments',
    'Exams'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          // Ensure endTime is after startTime
          if (_endTime.hour < _startTime.hour ||
              (_endTime.hour == _startTime.hour &&
                  _endTime.minute < _startTime.minute)) {
            _endTime = _startTime; // Set endTime to startTime if it's before
          }
        } else {
          _endTime = picked;
          // Ensure endTime is after startTime..
          if (_endTime.hour < _startTime.hour ||
              (_endTime.hour == _startTime.hour &&
                  _endTime.minute < _startTime.minute)) {
            _endTime = _startTime; // Set endTime to startTime if it's before
          }
        }
      });
    }
  }

  void _createTask() async {
    if (_taskNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task name cannot be empty.')),
      );
      return;
    }

    try {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      String userId = 'userId'; // Replace with the actual user ID

      // Convert TimeOfDay to 24-hour format strings..
      String startTime24 =
          '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
      String endTime24 =
          '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';

      await FirebaseFirestore.instance.collection("Tasks").doc(id).set({
        'taskName': _taskNameController.text,
        'category': _category,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'startTime': startTime24, // Store in 24-hour format..
        'endTime': endTime24, // Store in 24-hour format
        'description': _descriptionController.text,
        'userId': userId,
        'completed': 'false',
      });

      print('Task added to Firestore successfully!');
      Navigator.pop(context);
    } catch (e) {
      print('Error adding task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add task. Please try again.')),
      );
    }
  }

  void _addNewCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: _newCategoryController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _newCategoryController.clear();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (_newCategoryController.text.isNotEmpty) {
                  setState(() {
                    _categories.add(_newCategoryController.text);
                    _category = _newCategoryController.text;
                  });
                  Navigator.of(context).pop();
                  _newCategoryController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

 
   int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Task'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            // task name
            _createTaskName(),

            // select category
            _selectCategoryName(),

            // select date and time
            _selectTaskDate(),
            _selectStartTime(),
            _selectEndTime(),

            // note
            _addDescription(),

            // create task btn
            _createtaskBtn()
,            SizedBox(height: 20),
          ],
        ),
      ),
         bottomNavigationBar: MyBottomNavigationBarWidget(
        initialIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // widgets methods for body------
_createTaskName() {
  return TextField(
    
    controller: _taskNameController,
    maxLength: 30, // Add max lenght later
    decoration: InputDecoration(
      labelText: 'Task Name',
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      fillColor: const Color.fromARGB(255, 49, 49, 49),
      counterText: '', 
    ),
  );
}

Widget _selectCategoryName() {
  return Row(
    children: [
      Expanded(
        child: DropdownButton<String>(
          value: _category,
          items: _categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14.0, // Adjust font size
                  fontWeight: FontWeight.w400, // Adjust font weight
                  //color: const Color.fromARGB(255, 0, 0, 0), // Adjust text color
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _category = newValue!;
            });
          },
          isExpanded: true,
          style: TextStyle( // Style for the selected value
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: const Color.fromARGB(255, 24, 151, 75), // Change dropdown arrow color
          ),
          underline: Container( // Remove the underline
            height: 1,
            color: Colors.grey[300],
          ),
          dropdownColor: Colors.grey[100], // Change dropdown background color
        ),
      ),
      IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.green, // Change add icon color
        ),
        onPressed: () => _addNewCategory(context),
      ),
    ],
  );
}

  _selectTaskDate() {
    return ListTile(
      leading: Text(
        'Task Date:',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        ), // to temp align test
      title: Text(' ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
      trailing: Icon(
        Icons.calendar_today,
        color: const Color.fromARGB(255, 24, 151, 75), ),
      onTap: () => _selectDate(context),
    );
  }

  _selectStartTime() {
    return ListTile(
      leading: Text(
        'Start Time:',
          style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),),
      title: Text(' ${_startTime.format(context)}'),
      trailing: Icon(
        Icons.access_time,
        color: const Color.fromARGB(255, 24, 151, 75), ),
      onTap: () => _selectTime(context, true),
    );
  }

  _selectEndTime() {
    return ListTile(
      leading: Text(
        'End Time:',
          style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        ),
      title: Text(' ${_endTime.format(context)}'),
      trailing: Icon(
        Icons.access_time,
        color: const Color.fromARGB(255, 24, 151, 75), ),
      onTap: () => _selectTime(context, false),
    );
  }

  _addDescription() {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
         labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      ),
      minLines: 2,
      maxLines: 5,
      maxLength: 80,
    );
  }

  _createtaskBtn() {
    return ElevatedButton(
      onPressed: _createTask,
       style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: Colors.green,
                overlayColor: const Color.fromARGB(255, 36, 7, 255),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      child: Text('Create Task'),
    );
  }
}