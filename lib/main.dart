import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(CalendarApp());
}

class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Календарь'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(),
          _buildYearPicker(),
          _buildCalendar(),
          _buildCurrentMonthButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
            });
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(_selectedDate),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            setState(() {
              _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
            });
          },
        ),
      ],
    );
  }

  Widget _buildYearPicker() {
    return DropdownButton<int>(
      value: _selectedYear,
      items: List.generate(10, (index) {
        int year = DateTime.now().year - 5 + index;
        return DropdownMenuItem<int>(
          value: year,
          child: Text(year.toString()),
        );
      }),
      onChanged: (int? value) {
        setState(() {
          _selectedYear = value;
          _selectedDate = DateTime(_selectedYear ?? DateTime.now().year, _selectedDate.month, _selectedDate.day);
        });
      },
    );
  }

  Widget _buildCalendar() {
  return Table(
    children: [
      TableRow(
        children: List.generate(7, (index) {
          return Center(
            child: Text(
              DateFormat('E').format(DateTime(2023, 1, index + 2)),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }),
      ),
      for (int row = 0; row < 6; row++)
              TableRow(
        children: List.generate(7, (col) {
          DateTime day = DateTime(_selectedDate.year, _selectedDate.month, 1);
          int firstWeekday = day.weekday - 1;
          int currentDay = row * 7 + col - firstWeekday;
          day = day.add(Duration(days: currentDay));

          bool isCurrentMonthDay = day.month == _selectedDate.month;
          bool isToday = day.year == DateTime.now().year && day.month == DateTime.now().month && day.day == DateTime.now().day;

          return InkWell(
            onTap: () {
              if (isToday) {
                print('Selected: ${DateFormat('yyyy-MM-dd').format(day)}');
              }
            },
            child: Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isToday ? Colors.blue : (isCurrentMonthDay ? null : Colors.grey[300]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                day.day.toString(),
                style: TextStyle(
                  fontWeight: isToday ? FontWeight.bold : null,
                  color: isCurrentMonthDay ? (isToday ? Colors.white : Colors.black) : Colors.grey,
                ),
              ),
            ),
          );
        }),
      ),
    ],
  );
}



    Widget _buildCurrentMonthButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDate = DateTime.now();
          _selectedYear = DateTime.now().year;
        });
      },
      child: Text('Текущий месяц'),
    );
  }
}