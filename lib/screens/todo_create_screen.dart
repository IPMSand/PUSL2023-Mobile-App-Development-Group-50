import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../componments/bottom_navbar.dart'; 

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  String _category = 'Programming Language';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newCategoryController =
      TextEditingController(); // Controller for new category input
  final List<String> _categories = [
    'Programming Language',
    'Assignments',
    'Exams'
  ]; // List to hold categories.

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
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _createTask() {
    if (_taskNameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task name cannot be empty.')),
    );
    return; // Stop 
  }

    debugPrint('Task Name: ${_taskNameController.text}');
    debugPrint('Category: $_category');
    debugPrint('Date: ${_selectedDate.toLocal()}');
    debugPrint('Start Time: ${_startTime.format(context)}');
    debugPrint('End Time: ${_endTime.format(context)}');
    debugPrint('Description: ${_descriptionController.text}');
    

    Navigator.pop(context); 
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
                    _category = _newCategoryController
                        .text; //set new category as selected
                  });
                  Navigator.of(context).pop();
                  _newCategoryController
                      .clear(); //clear the controller after add.
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
         bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
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
      fillColor: const Color.fromARGB(255, 49, 49, 49),
      counterText: '', 
    ),
  );
}

  _selectCategoryName() {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            value: _category,
            items: _categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _category = newValue!;
              });
            },
            isExpanded: true,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _addNewCategory(context),
        ),
      ],
    );
  }

  _selectTaskDate() {
    return ListTile(
      leading: Text('Task Date:'), // to temp align test
      title: Text(' ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
      trailing: Icon(Icons.calendar_today),
      onTap: () => _selectDate(context),
    );
  }

  _selectStartTime() {
    return ListTile(
      leading: Text('Start Time:'),
      title: Text(' ${_startTime.format(context)}'),
      trailing: Icon(Icons.access_time),
      onTap: () => _selectTime(context, true),
    );
  }

  _selectEndTime() {
    return ListTile(
      leading: Text('End Time:'),
      title: Text(' ${_endTime.format(context)}'),
      trailing: Icon(Icons.access_time),
      onTap: () => _selectTime(context, false),
    );
  }

  _addDescription() {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
      ),
      maxLines: 3,
      maxLength: 80,
    );
  }

  _createtaskBtn() {
    return ElevatedButton(
      onPressed: _createTask,
       style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 36, 160, 92),
               
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      child: Text('Create Task'),
    );
  }
}
