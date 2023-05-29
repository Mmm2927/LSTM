import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import '../models/model.dart';
import 'package:intl/intl.dart';

class Main_Cctv extends StatefulWidget{
  final User userinfo;
  final getMyBabyFuction;
  const Main_Cctv(this.userinfo, {super.key, this.getMyBabyFuction});
  @override
  State<Main_Cctv> createState() => MainCCTVState();
}
class MainCCTVState extends State<Main_Cctv>{
  bool _isFlipped = true;
  bool _isPlaying = false;
  late Baby baby;

  @override
  void initState() {
    super.initState();
    baby = widget.getMyBabyFuction();
    print(baby.name);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffeeec),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xffffeeec),
        elevation: 0.5,
        iconTheme : const IconThemeData(color: Colors.black),
        title: const Text('홈캠', style:TextStyle(fontSize: 18, color: Color(0xffdf8570))),
      ),
      body: viewCCTV(),
    );
  }

  Widget viewCCTV() {
    String week = baby.relationInfo.Access_week.toRadixString(2);
    for (int i=week.length; i<7; i++) {
      week = '0$week';
    }
    var now = DateTime.now();
    String eeee = DateFormat('EEEE').format(now);
    String hour = DateFormat('hh:mm:ss').format(now);
    int realE = -1;
    switch (eeee) {
      case 'Monday':
        realE = 0;
        break;
      case 'Tuesday':
        realE = 1;
        break;
      case 'Wednesday':
        realE = 2;
        break;
      case 'Thursday':
        realE = 3;
        break;
      case 'Friday':
        realE = 4;
        break;
      case 'Saturday':
        realE = 5;
        break;
      case 'Sunday':
        realE = 6;
        break;
    }
    if (baby.relationInfo.relation == 0 || week[realE] == 1 && hour.compareTo(baby.relationInfo.Access_startTime) == -1 && hour.compareTo(baby.relationInfo.Access_endTime) == 1) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5)),
                alignment:Alignment.centerRight,
                padding: EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Text('아이 : ${baby.name}', style:const TextStyle(fontSize: 20, color: Color(0xffdf8570)))),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ClipRRect(
                    borderRadius : BorderRadius.circular(5.0),
                    child: Mjpeg(
                      isLive: _isPlaying,
                      error: (context, error, stack) {
                        print(error);
                        print(stack);
                        return Text(error.toString(),
                            style: const TextStyle(color: Color(0xffdf8570)));
                      },
                      stream:
                      'http://203.249.22.164:5000/video_feed', //'http://192.168.1.37:8081',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5)), //모서리를 둥글게
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 64,),
                      TextButton(
                        style: TextButton.styleFrom(padding:const EdgeInsets.fromLTRB(50,0,50,0)),
                        onPressed: () {
                          if (_isPlaying) {
                            setState(() {
                              _isPlaying = false;
                            });
                          } else {
                            setState(() {
                              _isPlaying = true;
                            });
                          }
                        },
                        child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 28,
                            color: Color(0xffdf8570)),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(alignment: Alignment.centerRight),
                        onPressed: () {
                          if (_isFlipped) {
                            setState(() {
                              WidgetsFlutterBinding.ensureInitialized();
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight,
                              ]);
                              _isFlipped = false;

                            });
                          } else {
                            setState(() {
                              WidgetsFlutterBinding.ensureInitialized();
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown,
                              ]);
                              _isFlipped = true;
                            });
                          }
                        },
                        child: const Icon(
                            Icons.autorenew,
                            size: 28,
                            color: Color(0xffdf8570)),
                      ),
                    ],
                  ),
                ),
                Container(margin: const EdgeInsets.fromLTRB(12, 0, 12, 0), height: 0.2, color: const Color(0xffdf8570)),
              ],
            ),
          ],
        ),
      );
    }
    else {
      String accessDay = '';
      for (int i=0; i<7; i++) {
        if (week[i] == '1') {
          switch (i) {
            case 0:
              accessDay += '월 ';
              break;
            case 1:
              accessDay += '화 ';
              break;
            case 2:
              accessDay += '수 ';
              break;
            case 3:
              accessDay += '목 ';
              break;
            case 4:
              accessDay += '금 ';
              break;
            case 5:
              accessDay += '토 ';
              break;
            case 6:
              accessDay += '일 ';
              break;
          }
        }
      };
      return Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('현재 ${baby.name}의 홈캠에 접근할 수 없습니다.\n', style: TextStyle(fontSize: 20)),
            Text('접근 가능 요일 : ${accessDay}\n', style: TextStyle(fontSize: 20)),
            Text('접근 가능 시간 : ${baby.relationInfo.Access_startTime} ~ ${baby.relationInfo.Access_endTime}\n', style: TextStyle(fontSize: 20))
          ]
        ),
      );
    }
  }
}