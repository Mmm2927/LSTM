import 'package:bob/screens/HomePage/BottomSheet/babyFood_bottom_sheet.dart';
import 'package:bob/screens/HomePage/BottomSheet/diaper_bottom_sheet.dart';
import 'package:bob/screens/HomePage/BottomSheet/feedingBottle_bottom_sheet.dart';
import 'package:bob/screens/HomePage/BottomSheet/growthRecord_bottom_sheet.dart';
import 'package:bob/screens/HomePage/BottomSheet/sleep_bottom_sheet.dart';
import 'package:bob/screens/HomePage/baby_medicalCheckup.dart';
import 'package:bob/screens/HomePage/baby_statistics.dart';
import 'package:bob/screens/HomePage/baby_vaccination.dart';
import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:bob/models/model.dart';
import 'package:bob/services/backend.dart';
import 'HomePage/BottomSheet/feeding_bottom_sheet.dart';

import 'package:bob/screens/HomePage/Stopwatch/feeding_stopwatch.dart';



class Main_Home extends StatefulWidget{
  final User userinfo;
  final List<Baby> babies;
  const Main_Home(this.babies, this.userinfo, {Key? key}) : super(key: key);

  @override
  _Main_home createState() => _Main_home();
}
class _Main_home extends State<Main_Home>{

  late int babyIdx;
  String _feeding = '-';        // 모유
  String _feedingBottle = '-';  // 젖병
  String _babyfood = '-';       // 이유식
  String _diaper = '-';         // 기저귀 
  String _sleep = '-';          // 수면

  void _timeFeeding(val){
    setState(() {
      _feeding = val;
    });
  }

  void _timeFeedingBottle(val){
    setState(() {
      _feedingBottle = val;
    });
  }

  void _timeBabyFood(val){
    setState(() {
      _babyfood = val;
    });
  }

  void _timeDiaper(val){
    setState(() {
      _diaper = val;
    });
  }

  void _timeSleep(val){
    setState(() {
      _sleep = val;
    });
  }

  change(){
    setState(() {
      timerClosed = true;
    });
  } // timerClosde 상태 변경 함수

  @override
  void initState() {
    babyIdx = 0;
    print(widget.babies.length);

  }

  bool timerClosed = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xF9F9F9FF),
        appBar: AppBar(
          backgroundColor: const Color(0xffffc8c7),
          elevation: 0.0,
          iconTheme : const IconThemeData(color: Colors.black),
          title: const Text('BoB', style: TextStyle(color: Colors.black,fontSize: 15)),
        ),
        drawer: Drawer(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.babies.length,
                itemBuilder: (BuildContext context, int index){
                  Baby baby = widget.babies[index];
                  return InkWell(
                      onTap: (){
                        setState(() {
                          babyIdx = index;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey)
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(baby.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            Text(baby.getGenderString()),
                            Text(DateFormat('yyyy년 MM월 dd일생').format(baby.birth)),
                          ],
                        ),
                      )
                  );
                }
            )
        ),
        //drawer 구현
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              child: Column(
                children: [
                  Container(
                      padding : const EdgeInsets.fromLTRB(10, 0, 10, 30),
                      decoration: const BoxDecoration(
                          color: Color(0xffffc8c7),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40)
                          )
                      ),
                      child: drawBaby(widget.babies[babyIdx].name, widget.babies[babyIdx].birth)
                  ),
                  //아기 정보 구현
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: const Color(0xfffdb1a5),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 3
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('버튼을 길게 누르면 타이머가 작동합니다.',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700]
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                topLeft: Radius.circular(20)
                                            )
                                        ),
                                        backgroundColor: Colors.purple[50],
                                        isScrollControlled: true,
                                        context: context,
                                        builder: ( BuildContext context ) {
                                          return FeedingBottomSheet(widget.babies[babyIdx].relationInfo.BabyId, _timeFeeding);
                                        }
                                    );
                                  },
                                  onLongPress: () async{
                                    setState(() {
                                      timerClosed = false;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.water_drop_outlined,), // <-- Icon
                                        Text("모유",style: TextStyle(fontSize: 15),), // <-- Text
                                      ],
                                    ),
                                  )
                              ),
                              InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                topLeft: Radius.circular(20)
                                            )
                                        ),
                                        backgroundColor: Colors.purple[50],
                                        isScrollControlled: true,
                                        context: context,
                                        builder: ( BuildContext context ) {
                                          return FeedingBottleBottomSheet(widget.babies[babyIdx].relationInfo.BabyId, _timeFeedingBottle);
                                        }
                                    );
                                  },
                                  onLongPress: (){
                                    setState(() {
                                      timerClosed = false;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.orange
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.water_drop,), // <-- Icon
                                        Text("젖병",style: TextStyle(fontSize: 15),), // <-- Text
                                      ],
                                    ),
                                  )
                              ),
                              InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                topLeft: Radius.circular(20)
                                            )
                                        ),
                                        backgroundColor: Colors.purple[50],
                                        isScrollControlled: true,
                                        context: context,
                                        builder: ( BuildContext context ) {
                                          return BabyFoodBottomSheet(widget.babies[babyIdx].relationInfo.BabyId, _timeBabyFood);
                                        }
                                    );
                                  },
                                  onLongPress: (){
                                    setState(() {
                                      timerClosed = false;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.yellow
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.rice_bowl_rounded,), // <-- Icon
                                        Text("이유식",style: TextStyle(fontSize: 15),), // <-- Text
                                      ],
                                    ),
                                  )
                              ),
                              InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                topLeft: Radius.circular(20)
                                            )
                                        ),
                                        backgroundColor: Colors.purple[50],
                                        isScrollControlled: true,
                                        context: context,
                                        builder: ( BuildContext context ) {
                                          return DiaperBottomSheet(widget.babies[babyIdx].relationInfo.BabyId, _timeDiaper);
                                        }
                                    );
                                  },
                                  onLongPress: (){
                                    setState(() {
                                      timerClosed = false;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.green
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.baby_changing_station,), // <-- Icon
                                        Text("기저귀",style: TextStyle(fontSize: 15),), // <-- Text
                                      ],
                                    ),
                                  )
                              ),
                              InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                topLeft: Radius.circular(20)
                                            )
                                        ),
                                        backgroundColor: Colors.purple[50],
                                        isScrollControlled: true,
                                        context: context,
                                        builder: ( BuildContext context ) {
                                          return SleepBottomSheet(widget.babies[babyIdx].relationInfo.BabyId, _timeSleep);
                                        }
                                    );
                                  },
                                  onLongPress: (){
                                    setState(() {
                                      timerClosed = false;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.blue
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.nights_stay_sharp,), // <-- Icon
                                        Text("수면",style: TextStyle(fontSize: 13),), // <-- Text
                                      ],
                                    ),
                                  )
                              )
                            ],
                          ),
                        ],
                      )
                  ),
                  //기록 button 구현
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BabyStatistics()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 15),
                      decoration: BoxDecoration(
                          color: const Color(0xffffc8c7),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 3
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('생활 기록', style: TextStyle(fontSize: 20, color: Colors.black)),
                          Row(
                            children: [
                              Expanded(flex:1,child: Text('모유', style: TextStyle(fontSize: 17, color: Colors.grey[600]))),
                              Expanded(flex:1,child: Text('젖병', style: TextStyle(fontSize: 17, color: Colors.grey[600])),)
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(flex:1,child: Center(child:Text( _feeding, style: TextStyle(fontSize: 20, color: Colors.grey[800])))),
                              Expanded(flex:1,child: Center(child:Text(_feedingBottle, style: TextStyle(fontSize: 20, color: Colors.grey[800]))))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(flex:1,child: Text('기저귀', style: TextStyle(fontSize: 17, color: Colors.grey[600]))),
                              Expanded(flex:1,child: Text('수면', style: TextStyle(fontSize: 17, color: Colors.grey[600])),)
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(flex:1,child: Center(child:Text(_diaper, style: TextStyle(fontSize: 20, color: Colors.grey[800]))),),
                              Expanded(flex:1,child: Center(child:Text(_sleep, style: TextStyle(fontSize: 20, color: Colors.grey[800])),))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //생활 기록 구현
                  Offstage(
                    offstage: timerClosed,
                    child: Container(
                      height: 90,
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
                      width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 3
                              )
                            ]
                        ),
                      child: FeedingStopwatch(widget.babies[babyIdx].name, timerClosedchange:change)
                    )
                  ),
                  //타이머 stage
                  Row(
                    children: [
                      Expanded(
                          flex:1,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 180,
                              margin: const EdgeInsets.fromLTRB(20, 0, 5, 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffffc8c7),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        spreadRadius: 3
                                    )
                                  ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('성장 기록',style: TextStyle(fontSize: 22, color: Colors.black)),
                                      IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(20),
                                                        topLeft: Radius.circular(20)
                                                    )
                                                ),
                                                backgroundColor: Colors.purple[50],
                                                isScrollControlled: true,
                                                context: context,
                                                builder: ( BuildContext context ) {
                                                  return GrowthRecordBottomSheet(widget.babies[babyIdx].relationInfo.BabyId);
                                                }
                                            );
                                          },
                                          icon: const Icon(Icons.add_circle)
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '키, 몸무게',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[700]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                      //성장기록 구현
                      Expanded(
                          flex:1,
                          child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                              child: Column(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Get.to(()=>BabyVaccination(widget.babies[babyIdx]));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        height: 80,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffffc8c7),
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 8,
                                                  spreadRadius: 3
                                              )
                                            ]
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('예방 접종', style: TextStyle(fontSize: 20, color: Colors.black),),
                                              Row(
                                                children: [
                                                  Text(
                                                    '다음 예방 접종 -> ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[700]
                                                    ),
                                                  ),
                                                  const Text(
                                                    '(예시)',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ]
                                        ),
                                      )
                                  ),
                                  //예방 접종 페이지 이동
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                      onTap: () {
                                        Get.to(()=>BabyMedicalCheckup(widget.babies[babyIdx]));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        height: 80,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffffc8c7),
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 8,
                                                  spreadRadius: 3
                                              )
                                            ]
                                        ),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('건강 검진', style: TextStyle(fontSize: 20, color: Colors.black),),
                                              Row(
                                                children: [
                                                  Text(
                                                    '다음 건강 검진 -> ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.grey[700]
                                                    ),
                                                  ),
                                                  const Text(
                                                    '(예시)',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ]
                                        ),
                                      )
                                  )
                                  //건강 검진 페이지 이동
                                ],
                              )
                          )
                      )
                      //예방 접종, 건강 검진 구현
                    ],
                  ),
                  //성장기록, 예방접종, 검강검진
                ],
              )
          )
        )
    );
  }
}

Widget drawBaby(String name, DateTime birth){
  final now = DateTime.now();
  return Container(
      padding: const EdgeInsets.only(left: 40),
      child: Column(
          children:[
            Row(
              children: [
                Image.asset('assets/images/baby.png',scale: 5,),
                const SizedBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(
                      '${birth.year}.${birth.month}.${birth.day}',
                      style: const TextStyle(fontSize: 25),
                    ),
                    Text(
                      'D+ ${DateTime(now.year, now.month, now.day).difference(birth).inDays+2}',
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                )
              ],
            )
          ]
      )
  );
}
//아기 정보 그리기