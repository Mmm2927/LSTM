import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MainDiary extends StatefulWidget {
  const MainDiary({super.key});

  @override
  State<MainDiary> createState() => MainDiaryState();
}

class MainDiaryState extends State<MainDiary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text(''),
      //),
      body: diaryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0))

        ),
        backgroundColor: const Color(0xfffa625f),
        child: const Icon(
            Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  DateTime selectedDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

  DateTime focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  diaryList() {
    return Column(
      children: [
        TableCalendar(
          availableCalendarFormats: const{
            CalendarFormat.twoWeeks : 'month',
            CalendarFormat.month : 'month',
            CalendarFormat.week : 'week'
          },
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
            // 선택된 날짜의 상태를 갱신합니다.
            setState(() {
              this.selectedDay = selectedDay;
              this.focusedDay = focusedDay;
            });
          },
          selectedDayPredicate: (DateTime day) {
            // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
            return isSameDay(selectedDay, day);
          },
          headerStyle: const HeaderStyle(
              formatButtonTextStyle: const TextStyle(color: Colors.white),
              formatButtonDecoration: const BoxDecoration(
                color: Color(0xfffa625f),
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              )
          ),
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              if (_calendarFormat == CalendarFormat.week) {
                _calendarFormat = CalendarFormat.month;
              } else {
                _calendarFormat = CalendarFormat.week;
              }
            });
          },
          onPageChanged: (focusedDay) {
            this.focusedDay = focusedDay;
          },
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Color(0xfffbaba9),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Color(0xfffa625f),
              shape: BoxShape.circle,
            ),
            weekendDecoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: Container(
            child: Text(DateFormat('yyyy-MM-dd').format(focusedDay)),
          ),
        ),
      ],
    );
  }
}