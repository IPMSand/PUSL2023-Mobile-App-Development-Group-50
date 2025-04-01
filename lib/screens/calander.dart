//--- this code works with firebase according to the add event page---

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime(2025, 2);
  final List<String> _weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  final Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        _events.clear();
        for (var doc in eventsSnapshot.docs) {
          final data = doc.data();
          final date = (data['date'] as Timestamp).toDate();
          final title = data['title'];
          final note = data['note'];
          final startTime = data['startTime'];

          String eventText = '$title - $note';
          if (startTime != null) {
            eventText = '$startTime - $title : $note';
          }

          final dateTimeKey = DateTime(date.year, date.month, date.day);
          if (_events[dateTimeKey] == null) {
            _events[dateTimeKey] = [];
          }
          _events[dateTimeKey]!.add(eventText.toUpperCase());
        }
      });
    }
  }

  int _getFirstDayOffset() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    int weekday = firstDay.weekday - 1;
    return weekday;
  }

  int _getDaysInMonth() {
    return DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
  }

  String _getMonthYearText() {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = _getDaysInMonth();
    final firstDayOffset = _getFirstDayOffset();
    List<Widget> dayWidgets = [];

    for (var weekday in _weekdays) {
      dayWidgets.add(Container(height: 30, alignment: Alignment.center, child: Text(weekday, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))));
    }

    for (int i = 0; i < firstDayOffset; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final hasEvents = _getEventsForDay(currentDate).isNotEmpty;
      final isSelected = _isSameDay(currentDate, _selectedDate);

      dayWidgets.add(GestureDetector(
        onTap: () => _onDaySelected(currentDate),
        child: Container(
          height: 32,
          width: 32,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.red.withOpacity(0.1)
                : hasEvents
                ? Colors.green.shade700.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            day.toString(),
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ));
    }

    return GridView.count(crossAxisCount: 7, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 4, crossAxisSpacing: 4, children: dayWidgets);
  }

  Widget _buildTimeSlotEvents() {
    final selectedDayEvents = _getEventsForDay(_selectedDate);

    return ListView.builder(
      itemCount: selectedDayEvents.length,
      itemBuilder: (context, index) {
        final event = selectedDayEvents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              event,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calander'), backgroundColor: Colors.greenAccent),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                const Text('Calender', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1))),
                Text(_getMonthYearText(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1))),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildCalendarGrid()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateFormat('EEEE, MMM d, y').format(_selectedDate).toUpperCase()} EVENTS',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _buildTimeSlotEvents()),
                ],
              ),
            ),
          ),
          Container(color: const Color(0xFFBCF5B1), padding: const EdgeInsets.symmetric(vertical: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [IconButton(icon: const Icon(Icons.home_outlined), onPressed: () {}), IconButton(icon: const Icon(Icons.shield_outlined), onPressed: () {}), IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}, color: Colors.black), IconButton(icon: const Icon(Icons.history), onPressed: () {})])),
        ],
      ),
    );
  }
}


