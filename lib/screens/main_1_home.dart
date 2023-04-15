import 'package:bob/screens/HomePage/babyFood_bottom_sheet.dart';
import 'package:bob/screens/HomePage/diaper_bottom_sheet.dart';
import 'package:bob/screens/HomePage/feedingBottle_bottom_sheet.dart';
import 'package:bob/screens/HomePage/sleep_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:bob/models/model.dart';
import 'package:bob/services/backend.dart';

import 'HomePage/feeding_bottom_sheet.dart';



class Main_Home extends StatefulWidget{
  final User userinfo;
  final List<Baby> babies;
  const Main_Home(this.babies, this.userinfo, {Key? key}) : super(key: key);

  @override
  _Main_home createState() => _Main_home();
}
class _Main_home extends State<Main_Home>{

  late int babyIdx;
  String _feeding = '-분 전';
  String _feedingBottle = '-분 전';
  String _babyfood = '-분 전';
  String _diaper = '-분 전';
  String _sleep = '-분 전';

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

  @override
  void initState() {
    babyIdx = 0;
    print(widget.babies.length);
  }
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
      // 앱바 구현
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
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xffffc8c7),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40)
                  )
                ),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                          height: 150,
                          child: drawBaby(
                              widget.babies[babyIdx].name,
                              widget.babies[babyIdx].birth
                          )
                      ),
                    ],
                  ),
                ),
              ),
          ),
          //아기 정보 구현
          Positioned(
              top: 130,
              child: Container(
                height: 90,
                width: MediaQuery.of(context).size.width-40,
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
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('버튼을 길게 누르면 타이머가 작동합니다.',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20,top: 10),
                      child: Row(
                        children: [
                          SizedBox.fromSize(
                            size: const Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.red,
                                child: InkWell(
                                  splashColor: Colors.white,
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
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.dining_outlined,), // <-- Icon
                                      Text("모유",style: TextStyle(fontSize: 15),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox.fromSize(
                            size: const Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.orange,
                                child: InkWell(
                                  splashColor: Colors.white,
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
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.water_drop,), // <-- Icon
                                      Text("젖병",style: TextStyle(fontSize: 15),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox.fromSize(
                            size: const Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.yellow,
                                child: InkWell(
                                  splashColor: Colors.white,
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
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.rice_bowl_rounded,), // <-- Icon
                                      Text("이유식",style: TextStyle(fontSize: 15),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),const SizedBox(
                            width: 20,
                          ),
                          SizedBox.fromSize(
                            size: const Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.green,
                                child: InkWell(
                                  splashColor: Colors.white,
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
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.baby_changing_station,), // <-- Icon
                                      Text("기저귀",style: TextStyle(fontSize: 15),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),const SizedBox(
                            width: 20,
                          ),
                          SizedBox.fromSize(
                            size: const Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue,
                                child: InkWell(
                                  splashColor: Colors.white,
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
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.nights_stay_sharp,), // <-- Icon
                                      Text("수면",style: TextStyle(fontSize: 13),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
          //기록 button 구현
          Positioned(
              top: 300,
              child: Column(
               children: [
                 Text(_feeding, style: TextStyle(fontSize: 20),),
                 Text(_feedingBottle, style: TextStyle(fontSize: 20),),
                 Text(_babyfood, style: TextStyle(fontSize: 20),),
                 Text(_diaper, style: TextStyle(fontSize: 20),),
                 Text(_sleep, style: TextStyle(fontSize: 20),),

               ]
              )
          )
        ],
      ),
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


