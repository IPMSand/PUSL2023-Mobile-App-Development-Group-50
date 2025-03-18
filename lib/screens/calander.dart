import 'package:flutter/material.dart';



class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now(); // Start with current date
  DateTime _focusedMonth = DateTime(2025, 2); // Set to February 2025 as shown in the UI
  final List<String> _weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  final List<String> _timeSlots = [
    '08.00AM', '09.00AM', '10.00AM', '11.00AM', '12.00PM', '01.00PM'
  ];

  // Simple event model
  final Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    // Add some sample events
    _events[DateTime(2025, 2, 12)] = ['Meeting with client', 'Lunch with team'];
  }

  int _getFirstDayOffset() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    // Convert to 0-6 where 0 is Monday (to match our weekday headers)
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

    // Add weekday headers
    for (var weekday in _weekdays) {
      dayWidgets.add(
          Container(
            height: 30,
            alignment: Alignment.center,
            child: Text(
              weekday,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          )
      );
    }

    // Add empty cells for the offset
    for (int i = 0; i < firstDayOffset; i++) {
      dayWidgets.add(Container());
    }

    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final hasEvents = _getEventsForDay(currentDate).isNotEmpty;
      final isSelected = _isSameDay(currentDate, _selectedDate);

      // Creating day cells with appropriate styling
      dayWidgets.add(
          GestureDetector(
            onTap: () => _onDaySelected(currentDate),
            child: Container(
              height: 32,
              width: 32,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.red.withOpacity(0.1)
                    : hasEvents
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.red : hasEvents ? Colors.blue : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          )
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
    );
  }

  Widget _buildTimeSlotEvents() {
    final selectedDayEvents = _getEventsForDay(_selectedDate);

    return ListView.builder(
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = _timeSlots[index];
        final hasEventForTimeSlot = index < selectedDayEvents.length;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  timeSlot,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  child: hasEventForTimeSlot
                      ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      selectedDayEvents[index],
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
                      : const SizedBox(height: 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBCF5B1), // Light green background
        title: const Text(
          'Calender', // Matching the spelling in the UI
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Top navigation bar
          Container(
            color: const Color(0xFFBCF5B1), // Light green background
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_outline),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Calendar Title and Icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                const Text(
                  'Calender', // Matching the spelling in the UI
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Month navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month - 1,
                      );
                    });
                  },
                ),
                Text(
                  _getMonthYearText(), // Dynamic month and year
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          // Calendar grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCalendarGrid(),
          ),

          // Upcoming events section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () {
                          // Show dialog to add a new event
                          _showAddEventDialog(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildTimeSlotEvents(),
                  ),
                ],
              ),
            ),
          ),

          // Bottom navigation bar
          Container(
            color: const Color(0xFFBCF5B1), // Light green background
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.home_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.shield_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {},
                  color: Colors.black, // Selected icon
                ),
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final TextEditingController _eventController = TextEditingController();
    final TextEditingController _timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Event for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: const InputDecoration(
                labelText: 'Event Title',
              ),
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time (e.g., 10.00AM)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_eventController.text.isNotEmpty) {
                setState(() {
                  final key = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
                  if (_events[key] == null) {
                    _events[key] = [];
                  }
                  _events[key]!.add(_eventController.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}