import 'package:flutter/material.dart';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateTodoPageState createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  String taskName = '';
  String category = 'Programming Language'; // Default category
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2);
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Task'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskNameInput(),
          SizedBox(height: 20),
          _buildCategorySelection(),
          SizedBox(height: 20),
          _buildDateTimeSelection(),
          SizedBox(height: 20),
          _buildTimeSelection(),
          SizedBox(height: 20),
          _buildDescriptionInput(),
          SizedBox(height: 20),
          _buildCreateTaskButton(),
        ],
      ),
    );
  }

  Widget _buildTaskNameInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Task Name'),
      onChanged: (value) => taskName = value,
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category'),
        SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => setState(() => category = 'Programming Language'),
              style: ElevatedButton.styleFrom(
                backgroundColor: category == 'Programming Language' ? Colors.blue : Colors.grey,
              ),
              child: Text('Programming Language'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => setState(() => category = 'QUIZ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: category == 'QUIZ' ? Colors.blue : Colors.grey,
              ),
              child: Text('QUIZ'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date & Time'),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2025),
            );
            if (picked != null && picked != selectedDate) {
              setState(() {
                selectedDate = picked;
              });
            }
          },
          child: Text('${selectedDate.day}th ${getMonthName(selectedDate.month)}, ${selectedDate.year}'),
        ),
      ],
    );
  }

  String getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildTimeSelection() {
    return Row(
      children: [
        _buildTimePicker('Start Time', startTime, (time) => startTime = time),
        SizedBox(width: 20),
        _buildTimePicker('End Time', endTime, (time) => endTime = time),
      ],
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, Function(TimeOfDay) onTimeChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null && picked != time) {
              onTimeChanged(picked);
              setState(() {}); // Trigger a rebuild to update the UI
            }
          },
          child: Text(time.format(context)),
        ),
      ],
    );
  }

  Widget _buildDescriptionInput() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      onChanged: (value) => description = value,
      maxLines: 3,
    );
  }

  Widget _buildCreateTaskButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // For now, just debug print the values
          debugPrint('Task Name: $taskName');
          debugPrint('Category: $category');
          debugPrint('Date: ${selectedDate.day}th ${getMonthName(selectedDate.month)}, ${selectedDate.year}');
          debugPrint('Start Time: ${startTime.format(context)}');
          debugPrint('End Time: ${endTime.format(context)}');
          debugPrint('Description: $description');
        },
        child: Text('Create Task'),
      ),
    );
  }
}