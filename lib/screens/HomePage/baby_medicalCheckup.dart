import 'package:flutter/material.dart';

class BabyMedicalCheckup extends StatefulWidget {
  final String babyname;
  final DateTime babybirth;

  const BabyMedicalCheckup(this.babyname, this.babybirth, {Key? key}) : super(key: key);

  @override
  State<BabyMedicalCheckup> createState() => _BabyMedicalCheckup();
}

class _BabyMedicalCheckup extends State<BabyMedicalCheckup> {
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
        child: Text('this page is MedicalCheckup',style: TextStyle(fontSize: 25),),
      ),
    );
  }
}
