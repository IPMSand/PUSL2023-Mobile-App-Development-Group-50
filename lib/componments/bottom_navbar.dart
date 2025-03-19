import 'package:flutter/material.dart';

class MyBottomNavigationBarWidget extends StatefulWidget {
  final int initialIndex;
  final Function(int) onItemTapped;

  const MyBottomNavigationBarWidget({super.key, 
    required this.initialIndex,
    required this.onItemTapped,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyBottomNavigationBarWidgetState createState() => _MyBottomNavigationBarWidgetState();
}

class _MyBottomNavigationBarWidgetState extends State<MyBottomNavigationBarWidget> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.shield_moon_rounded), label: "To Do List"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calender"),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Timer"),
      ],
    );
  }
}
// TODO: here when clicking on the icon it should display that page