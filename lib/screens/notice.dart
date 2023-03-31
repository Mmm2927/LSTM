import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';

class Notice extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('알림'),
      body: Center(child: Text('HI'),),
    );
  }

}