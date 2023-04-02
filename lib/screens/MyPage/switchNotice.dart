import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';

class SwitchNotice extends StatefulWidget{
  //ManageBabyWidget(User? userInfo);
  @override
  State<SwitchNotice> createState() => _SwitchNotice();
}
class _SwitchNotice extends State<SwitchNotice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('알림 ON / OFF'),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Text('-')
      )
    );
  }

}