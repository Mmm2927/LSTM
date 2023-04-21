import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/database.dart';
import '../database/diaryDB.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:bob/widgets/appbar.dart';

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
        appBar: renderAppbar_with_alarm('BoB', context),
        resizeToAvoidBottomInset: false,
        body: diaryList(),
        floatingActionButton: FutureBuilder<bool>(
            future: DatabaseHelper.instance.isDiary(selectedDay),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return const Center(
                  child: null,
                );
              }
              return FloatingActionButton(
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
                            backgroundColor: const Color(0xfffffdfd),
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
              );
            }
        )
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
          locale: 'ko_KR',
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
              DatabaseHelper.instance.isDiary(selectedDay);
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
        FutureBuilder<Diary>(
            future: DatabaseHelper.instance.getDiary(selectedDay),
            builder: (BuildContext context, AsyncSnapshot<Diary> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: Text('No Today Diary')
                );
              }
              return snapshot.data == null
                  ? const Center(child: Text('No Today Diary'))
                  : Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    scrollDirection: Axis.vertical,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.title, style:const TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
                          const SizedBox(height:10),
                          Text(snapshot.data!.date, style:const TextStyle(fontSize:13, color:Colors.blueGrey)),
                          const SizedBox(height:10, width: double.infinity,),
                          Center(child: snapshot.data!.image == null? const SizedBox(height:10, width: double.infinity,) : Image.file(File(snapshot.data!.image ?? 'default'), width: MediaQuery.of(context).size.width/2) ,),
                          const SizedBox(height:10, width: double.infinity,),
                          Text(snapshot.data!.content, style:const TextStyle(fontSize:16)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(onPressed: (() async {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: AlertDialog(
                                          content: Form(
                                            key: _formKey,
                                            child: updateDiary(selectedDay, snapshot.data),
                                          ),
                                          insetPadding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                                          backgroundColor: const Color(0xfffffdfd),
                                        ),
                                      );
                                    }
                                );
                              }), style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xff625ffa),
                                    width: 0.5,
                                  )
                              ),
                                  child: const Text('수정', style: TextStyle(color: Color(0xff625ffa)))),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  onPressed: () {
                                    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                      content: const Text('삭제하시겠습니까?'),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () => Navigator.of(context).pop(), child: const Text('취소')),
                                        ElevatedButton(
                                            onPressed: (() async {
                                              setState(() {
                                                DatabaseHelper.instance.remove(selectedDay);
                                              });
                                              Navigator.of(context).pop();
                                            }),
                                            child: Text('삭제')),
                                      ],
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Color(0xfffa625f),
                                        width: 0.5,
                                      )
                                  ),child: const Text('삭제', style: TextStyle(color: Color(0xfffa625f)))),
                            ],
                          ),
                        ]
                    )
                ),
              );
            }
        )
      ],
    );
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  updateDiary(DateTime selectedDay, Diary? diary) {
    String title = diary!.title;
    String content = diary!.content;
    String? image = diary!.image;
    String selDay = DateFormat('yyyy.MM.dd').format(selectedDay);
    XFile? preImage;
    final ImagePicker picker = ImagePicker();

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
            cursorColor: Color(0xfffa625f),
            initialValue: diary.title,
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
              floatingLabelStyle: TextStyle(color: Color(0xfffa625f)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width:1.5, color: Color(0xfffa625f))
              ),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 16.0,
            width: 5000,
          ),
          TextFormField(
            cursorColor: Color(0xfffa625f),
            maxLines: 15,
            keyboardType: TextInputType.multiline,
            initialValue: diary.content,
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
              floatingLabelStyle: TextStyle(color: Color(0xfffa625f)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width:1.5, color: Color(0xfffa625f))
              ),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: (() async {
                final XFile? _image = await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  preImage = _image;
                  image = _image!.path;
                });
              }), style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xff625ffa),
                    width: 0.5,
                  )
              ),
                  child: Text(image != null? '사진 바꾸기' : '사진 첨부', style: TextStyle(color: Color(0xff625ffa)))),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      DatabaseHelper.instance.update(Diary(date: selDay, title: title, content: content, image: image));
                      _formKey.currentState?.reset();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('수정 되었습니다.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xfffa625f),
                        width: 0.5,
                      )
                  ),child: const Text('수정', style: TextStyle(color: Color(0xfffa625f)))
              ),
              if(image != null) Expanded(
                child: Image.file(File(image!)),
              ),
            ],
          ),
        ]
    );
  }

  writeDiary(DateTime selectedDay) {
    String title = '';
    String content = '';
    String? image;
    String selDay = DateFormat('yyyy.MM.dd').format(selectedDay);
    XFile? preImage;
    final ImagePicker picker = ImagePicker();

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
            cursorColor: Color(0xfffa625f),
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
              floatingLabelStyle: TextStyle(color: Color(0xfffa625f)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width:1.5, color: Color(0xfffa625f))
              ),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 16.0,
            width: 5000,
          ),
          TextFormField(
            cursorColor: Color(0xfffa625f),
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
              floatingLabelStyle: TextStyle(color: Color(0xfffa625f)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width:1.5, color: Color(0xfffa625f))
              ),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: (() async {
                final XFile? _image = await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  preImage = _image;
                  image = _image!.path;
                });
              }), style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xff625ffa),
                    width: 0.5,
                  )
              ),
                  child: Text(image != null? '사진 바꾸기' : '사진 첨부', style: const TextStyle(color: Color(0xff625ffa)))),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      DatabaseHelper.instance.add(Diary(date: selDay, title: title, content: content, image: image));
                      _formKey.currentState?.reset();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('업로드 되었습니다.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xfffa625f),
                        width: 0.5,
                      )
                  ),child: const Text('업로드', style: TextStyle(color: Color(0xfffa625f)))
              ),
              if(image != null) Expanded(
                child: Image.file(File(image!)),
              ),
            ],
          ),
        ]
    );
  }
}