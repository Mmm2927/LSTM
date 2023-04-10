import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SwitchNotice extends StatefulWidget{
  List<Baby> babies;
  SwitchNotice(this.babies, {super.key});
  @override
  State<SwitchNotice> createState() => _SwitchNotice();
}
class _SwitchNotice extends State<SwitchNotice> {
  DateTime now = DateTime.now();
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('알림 ON / OFF' , true),
      body: Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.babies.length,
            itemBuilder: (BuildContext context, int index){
              return drawBaby(widget.babies[index]);
            }
        )
      )
    );
  }
  Widget drawBaby(Baby baby){
    return Card(
      elevation: 2,
      shadowColor: Colors.grey[50],
      child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(baby.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  SizedBox(width: 10),
                  Chip(
                    label: Text('D+ ${DateTime(now.year, now.month, now.day).difference(baby.birth).inDays+2}'),
                    backgroundColor: const Color(0xffffc8c7),
                  )
                ],
              ),
              Row(
                children: [
                  Text('영상 탐지 알림'),
                  SizedBox(width: 10),
                  FlutterSwitch(
                      showOnOff: true,
                      width: 60,
                      height: 25,
                      activeTextColor: Colors.white,
                      value: status,
                      onToggle: (val){
                        setState(() {
                          status = val;
                        });
                      }
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('음성 탐지 알림'),
                  SizedBox(width: 10),
                  FlutterSwitch(
                      showOnOff: true,
                      width: 60,
                      height: 25,
                      activeTextColor: Colors.white,
                      value: status,
                      onToggle: (val){
                        setState(() {
                          status = val;
                        });
                      }
                  )
                ],
              )
            ],
          )
      )
    );
  }
}