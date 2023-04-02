import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';

class Invitation extends StatefulWidget{
  //ManageBabyWidget(User? userInfo);
  @override
  State<Invitation> createState() => _Invitation();
}
class _Invitation extends State<Invitation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('양육자 / 베이비시터 초대'),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Text('-')
      )
    );
  }

}