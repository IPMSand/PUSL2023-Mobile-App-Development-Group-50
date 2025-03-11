import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  String _category = 'Task Category';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController(); // Controller for new category input
  final List<String> _categories = ['Modules', 'Assignments','Exams']; // List to hold categories

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
    debugPrint('Task Name: ${_taskNameController.text}');
    debugPrint('Category: $_category');
    debugPrint('Date: ${_selectedDate.toLocal()}');
    debugPrint('Start Time: ${_startTime.format(context)}');
    debugPrint('End Time: ${_endTime.format(context)}');
    debugPrint('Description: ${_descriptionController.text}');

    // You can add logic here to pass the data back to the first screen
    // or store it in a state management solution.

    Navigator.pop(context); // Go back to the first screen
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
                _newCategoryController.clear(); //clear the controller
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_newCategoryController.text.isNotEmpty) {
                  setState(() {
                    _categories.add(_newCategoryController.text);
                    _category = _newCategoryController.text; //set new category as selected
                  });
                  Navigator.of(context).pop();
                  _newCategoryController.clear(); //clear the controller after add.
                }
              },
            ),
          ],
        );
      },
    );
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
        child: ListView(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 20),
            Row(
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
            ),
            SizedBox(height: 20),
            ListTile(
            title: Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text('Start Time: ${_startTime.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, true),
            ),
            ListTile(
              title: Text('End Time: ${_endTime.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, false),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTask,
              child: Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}