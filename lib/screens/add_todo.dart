// this page works after adding firbase to the project
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:mad_project/servieces/models/todo_taks_class.dart';

import '../widgets/bottom_navbar.dart';

class CreateTaskScreen extends StatefulWidget {
  
  
  const CreateTaskScreen({super.key,});

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
          if (_endTime.hour < _startTime.hour ||
              (_endTime.hour == _startTime.hour &&
                  _endTime.minute < _startTime.minute)) {
            _endTime = _startTime;
          }
        } else {
          _endTime = picked;
          if (_endTime.hour < _startTime.hour ||
              (_endTime.hour == _startTime.hour &&
                  _endTime.minute < _startTime.minute)) {
            _endTime = _startTime;
          }
        }
      });
    }
  }

  void _createTask() async {
    if (_taskNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task name cannot be empty.')),
      );
      return;
    }

    try {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in.')),
        );
        return;
      }
      String userId = user.uid;

      String startTimeAmPm = _startTime.format(context);
      String endTimeAmPm = _endTime.format(context);

      await FirebaseFirestore.instance.collection("Tasks").doc(id).set({
        'taskName': _taskNameController.text,
        'category': _category,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'startTime': startTimeAmPm,
        'endTime': endTimeAmPm,
        'description': _descriptionController.text,
        'userId': userId,
        'completed': 'false',
      });

      print('Task added to Firestore successfully!');
      Navigator.pop(context);
    } catch (e) {
      print('Error adding task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task. Please try again.')),
      );
    }
  }

  void _addNewCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Category'),
          content: TextField(
            controller: _newCategoryController,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _newCategoryController.clear();
              },
            ),
            TextButton(
              child: Text('Add'),
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
            _createTaskName(),
            _selectCategoryName(),
            _selectTaskDate(),
            _selectStartTime(),
            _selectEndTime(),
            _addDescription(),
            _createtaskBtn(),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBarWidget(
        initialIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  _createTaskName() {
    return TextField(
      controller: _taskNameController,
      maxLength: 30,
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
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
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
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: const Color.fromARGB(255, 24, 151, 75),
            ),
            underline: Container(
              height: 1,
              color: Colors.grey[300],
            ),
            dropdownColor: Colors.grey[100],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.green,
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
      ),
      title: Text(' ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
      trailing: Icon(
        Icons.calendar_today,
        color: const Color.fromARGB(255, 24, 151, 75),
      ),
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
        ),
      ),
      title: Text(' ${_startTime.format(context)}'),
      trailing: Icon(
        Icons.access_time,
        color: const Color.fromARGB(255, 24, 151, 75),
      ),
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
        color: const Color.fromARGB(255, 24, 151, 75),
      ),
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
            fontWeight: FontWeight.bold,
          )),
      child: Text('Create Task'),
    );
  }
}