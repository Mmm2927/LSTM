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
  State<Main_Home> createState() => _MainHome();
}
class _MainHome extends State<Main_Home>{
  late List<Baby> activeBabies;
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
    super.initState();
    babyIdx = 0;
    activeBabies = [];
    for(int i=0; i<widget.babies.length; i++){
      Baby baby = widget.babies[i];
      if(baby.relationInfo.active){
        activeBabies.add(baby);
      }
    }
  }
  bool timerClosed = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xF9F9F9FF),
        appBar: AppBar(
          backgroundColor: const Color(0x83fa625f),
          elevation: 0.0,
          iconTheme : const IconThemeData(color: Colors.black),
          title: const Text('BoB', style: TextStyle(color: Colors.black,fontSize: 15)),
        ),
        drawer: Drawer(
            child: Container(
              padding: const EdgeInsets.all(10),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text('아기 리스트', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  const Text('클릭하면 해당 아기를 관리할 수 있습니다', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  Expanded(
                      child: ListView(
                        children: [
                          SingleChildScrollView(
                            child:ExpansionTile(
                                initiallyExpanded: true,
                                title: const Text('부모', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                children: getDrawerData(0, context, Colors.pinkAccent)
                            ),
                          ),
                          SingleChildScrollView(
                            child:ExpansionTile(
                                initiallyExpanded: true,
                                title: const Text('가족', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                children: getDrawerData(1, context, Colors.blueAccent)
                            ),
                          ),
                          SingleChildScrollView(
                            child:ExpansionTile(
                                initiallyExpanded: true,
                                title: const Text('베이비시터', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                children: getDrawerData(2, context, Colors.grey)
                            ),
                          ),

                        ],
                      ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
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
                          color: Color(0x83fa625f),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40)
                          )
                      ),
                      child: drawBaby(activeBabies[babyIdx].name, activeBabies[babyIdx].birth)
                  ),
                  //아기 정보 구현
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text('버튼을 길게 누르면 타이머가 작동합니다.',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700]
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              drawRecordButton(context, '모유', Icons.water_drop_outlined, Colors.red, const Color(0xffffdbd9), 0),
                              drawRecordButton(context, '젖병', Icons.water_drop, Colors.orange, const Color(0xfffae2be), 1),
                              drawRecordButton(context, '이유식', Icons.rice_bowl_rounded, const Color(0xfffacc00), const Color(0xfffff7d4), 2),
                              drawRecordButton(context, '기저귀', Icons.baby_changing_station, Colors.green, const Color(0xffedfce6), 3),
                              drawRecordButton(context, '수면', Icons.nights_stay_sharp, Colors.blueAccent, const Color(0xffe6eafc), 4)
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
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
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                    )
                                  ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('성장 기록',style: TextStyle(fontSize: 22, color: Colors.black)),
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
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 5,
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
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 5,
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
  List<InkWell> getDrawerData(int relation, BuildContext context, Color color){
    List<InkWell> datas = [];
    for(int i=0; i<activeBabies.length; i++){
      Baby b = activeBabies[i];
      if(b.relationInfo.relation == relation){
        datas.add(
          InkWell(
            onTap: (){
              setState(() {
                babyIdx = i;
              });
              Navigator.pop(context);
            },
              child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                      )
                    ],
                    border: Border(
                      left: BorderSide(
                          color: color,
                          width: 3.0
                      ),
                    ),
                    color: Colors.white,
                    //borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.fromLTRB(2,10,2,10),
                  child: Row(
                    children: [
                      Text(b.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(DateFormat('yyyy년 MM월 dd일생').format(b.birth)+', '+ (b.getGenderString()=='F'?"여자":"남자")),
                          ],
                        ),
                      )
                    ],
                  )
              )
          )
        );
      }
    }
    return datas;
  }
  InkWell drawRecordButton(BuildContext rootContext, String type, IconData iconData, Color background, Color color, int tapMode){
    return InkWell(
      onTap: () => record_with_ModalBottomSheet(rootContext, tapMode),
      onLongPress: (){
        setState(() {
          timerClosed = false;
        });
      },
      child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(iconData, color: background), // <-- Icon
              Text(type, style: TextStyle(fontSize: 13, color: background)), // <-- Text
            ],
          ),
      )
    );
  }
  record_with_ModalBottomSheet(BuildContext rootContext, int tapMode){
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)
            )
        ),
        backgroundColor: Colors.purple[50],
        isScrollControlled: true,
        context: rootContext,
        builder: (BuildContext context) {
          if(tapMode==0){
            return FeedingBottomSheet(activeBabies[babyIdx].relationInfo.BabyId, _timeFeeding);
          }else if(tapMode==1){
            return FeedingBottleBottomSheet(activeBabies[babyIdx].relationInfo.BabyId, _timeFeedingBottle);
          }
          else if(tapMode==2){
            return BabyFoodBottomSheet(activeBabies[babyIdx].relationInfo.BabyId, _timeBabyFood);
          }
          else if(tapMode==3){
            return DiaperBottomSheet(activeBabies[babyIdx].relationInfo.BabyId, _timeDiaper);
          }
          else{
            return SleepBottomSheet(activeBabies[babyIdx].relationInfo.BabyId, _timeSleep);
          }
        }
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