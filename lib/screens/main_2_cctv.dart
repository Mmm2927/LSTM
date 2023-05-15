import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
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
      appBar: renderAppbar_with_alarm('BoB', context),
      body: SingleChildScrollView(
        child:
        viewCCTV(),
      ),
    );
  }

  Widget viewCCTV() {
    String week = baby.relationInfo.Access_week.toRadixString(2);
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
      case 'Wednesdady':
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
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: Mjpeg(
              isLive: _isPlaying,
              error: (context, error, stack) {
                print(error);
                print(stack);
                return Text(error.toString(),
                    style: const TextStyle(color: Colors.red));
              },
              stream:
              'http://203.249.22.164:5000/video_feed', //'http://192.168.1.37:8081',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'video',
                child: TextButton(
                  onPressed: () {},
                  child: const Icon(
                      Icons.fast_rewind,
                      size: 28,
                      color: Colors.black),
                ),
              ),
              TextButton(
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
                    color: Colors.black),
              ),
              TextButton(
                onPressed: () {},
                child: const Icon(
                    Icons.fast_forward,
                    size: 28,
                    color: Colors.black),
              ),
            ],
          ),
          Text('현재 아기 : ${baby.name}'),
        ],
      );
    }
    else {
      return Container(height: 100, alignment: Alignment(0,0), child: Text('현재 ${baby.name}의 홈캠에 접근할 수 없습니다.\n', style: TextStyle(fontSize: 20)));
    }
  }
}