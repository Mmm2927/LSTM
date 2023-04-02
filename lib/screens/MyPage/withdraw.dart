import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';

class WithdrawService extends StatefulWidget{
  //ManageBabyWidget(User? userInfo);
  @override
  State<WithdrawService> createState() => _WithdrawService();
}
class _WithdrawService extends State<WithdrawService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('서비스 탈퇴'),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Text('-')
      )
    );
  }

}