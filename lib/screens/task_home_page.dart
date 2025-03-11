import 'package:flutter/material.dart';
import 'package:mad_project/screens/to_create.dart';
// Import the second page

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTodoPage()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 20),
            _buildProgressSummary(),
            SizedBox(height: 20),
            _buildTodaysTasks(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Welcome', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        // Add any welcome image or icon here
      ],
    );
  }

  Widget _buildProgressSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today\'s progress Summary', style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('15 tasks'),
            Text('progress 40%'),
          ],
        ),
        // Add progress bar here
      ],
    );
  }

  Widget _buildTodaysTasks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Today\'s Task', style: TextStyle(fontSize: 18)),
            TextButton(
              onPressed: () {
                // Navigate to see all tasks
              },
              child: Text('See All'),
            ),
          ],
        ),
        _buildTaskItem(context, 'HTML', '09.00 AM - 11.00 AM'),
        _buildTaskItem(context, 'CSS', '11.30 AM - 01.30 PM'),
        _buildTaskItem(context, 'PHP', '2.00 PM - 04.00 PM'),
        _buildTaskItem(context, 'QUIZ', '04.30 PM - 05.30 PM'),
      ],
    );
  }

  Widget _buildTaskItem(BuildContext context, String title, String time) {
    return ListTile(
      title: Text(title),
      subtitle: Text(time),
      trailing: IconButton(
        icon: Icon(Icons.chevron_right),
        onPressed: () {
          // Navigate to task details page
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Completed'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
      ],
      // Add logic for currentIndex and onTap if needed
    );
  }
}