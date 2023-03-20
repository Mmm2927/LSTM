import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/database.dart';
import '../database/diaryDB.dart';

class MainDiary extends StatefulWidget {
  const MainDiary({super.key});
  @override
  State<MainDiary> createState() => MainDiaryState();
}

class MainDiaryState extends State<MainDiary> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text(''),
      //),
      resizeToAvoidBottomInset: false,
      body: diaryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: AlertDialog(
                  content: Form(
                    key: _formKey,
                    child: writeDiary(selectedDay),
                  ),
                  insetPadding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                  backgroundColor: const Color(0xffffffff),
                ),
              );
            }
          );
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
              formatButtonTextStyle: TextStyle(color: Colors.white),
              formatButtonDecoration: BoxDecoration(
                color: Color(0xfffa625f),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
        const SizedBox(height: 20),
        Center(
          child: FutureBuilder<Diary>(
            future: DatabaseHelper.instance.getDiary(selectedDay),
            builder: (BuildContext context, AsyncSnapshot<Diary> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No Today Diary')
                );
              }
              return snapshot.data == null
                  ? const Center(child: Text('No Today Diary'))
                  : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                      child: Text(snapshot.data!.title, style:const TextStyle(fontSize:18, fontWeight: FontWeight.bold))
                    ),
                    const SizedBox(height:10),
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                        child: Text(snapshot.data!.date, style:const TextStyle(fontSize:13, color:Colors.blueGrey))
                    ),
                    const SizedBox(height:10, width: double.infinity,),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                      child: Text(snapshot.data!.content, style:const TextStyle(fontSize:16)),
                    ),
                ]
              ),
                  );
            }
          )
        )
      ],
    );
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  writeDiary(DateTime selectedDay) {
    String title = '';
    String content = '';
    String image;
    String selDay = DateFormat('yyyy.MM.dd').format(selectedDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        TextButton(
          child: const Icon(Icons.clear, color: Color(0xfffa625f)),
          onPressed: () {
            _formKey.currentState?.reset();
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(
          height: 5.0,
        ),
        TextFormField(
          controller: _titleController,
          onSaved: (value) {
            setState(() {
              title = value as String;
            });
          },
          validator: (value) {
            if (value!.trim().isEmpty) {
              return '제목을 입력하세요.';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: '제목',
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 16.0,
          width: 5000,
        ),
        TextFormField(
          maxLines: 15,
          keyboardType: TextInputType.multiline,
          controller: _contentController,
          onSaved: (value) {
            setState(() {
              content = value as String;
            });
          },
          validator: (value) {
            if (value!.trim().isEmpty) {
              return '내용을 입력하세요.';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: '내용',
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 16.0,
          width: 5000,
        ),
        ElevatedButton(onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            DatabaseHelper.instance.add(Diary(date: selDay, title: title, content: content));
            _formKey.currentState?.reset();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('업로드 되었습니다.')),
            );
          }
        }, child: const Text('업로드')),
      ]
    );
  }
}