import 'package:bob/widgets/appbar.dart';
import 'package:flutter/material.dart';

class BabyStatistics extends StatefulWidget {
  const BabyStatistics({Key? key}) : super(key: key);

  @override
  State<BabyStatistics> createState() => _BabyStatisticsState();
}

class _BabyStatisticsState extends State<BabyStatistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffc8c7),
        elevation: 0.0,
        iconTheme : const IconThemeData(color: Colors.black),
        title: const Text('생활기록', style: TextStyle(color: Colors.black,fontSize: 20)),
      ),
      body: Container(
        child: Text('this page is babystatistics',style: TextStyle(fontSize: 25),),
      ),
    );
  }
}
