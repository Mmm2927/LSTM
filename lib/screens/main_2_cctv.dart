import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';

class Main_Cctv extends StatefulWidget{
  @override
  _Main_Cctv createState() => _Main_Cctv();
}
class _Main_Cctv extends State<Main_Cctv>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar_with_alarm('BoB', context),
    );
  }
}