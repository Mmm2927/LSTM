import 'dart:developer';
import 'dart:ffi';
import 'package:bob/models/model.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BabyGrowthStatistics extends StatefulWidget {
  final Baby baby;
  final List<GrowthRecord> growthRecords;
  const BabyGrowthStatistics(this.baby, this.growthRecords, {Key? key}) : super(key: key);

  @override
  State<BabyGrowthStatistics> createState() => _BabyGrowthStatisticsState();
}

class _BabyGrowthStatisticsState extends State<BabyGrowthStatistics> with TickerProviderStateMixin {
  List<Color> gradientColors = [
    Colors.black,
    Colors.blue
  ];
  late TabController _tabController;
  late Future getGrowthFuture;
  bool showAvg = false;

  List<FlSpot> weightPoints = [];
  List<FlSpot> heightPoints = [];

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(
        length: 2,
        vsync: this,
    );
    super.initState();
    //print(widget.baby.relationInfo.BabyId);
    getGrowthFuture = getMyGrowthInfo();
  }
  double maxD = DateTime.now().millisecondsSinceEpoch.toDouble();
  double minD = DateTime.now().millisecondsSinceEpoch.toDouble();

  Future getMyGrowthInfo() async{
    List<dynamic> growthRecordList = await growthGetService(widget.baby.relationInfo.BabyId);
    for(int i=0; i<growthRecordList.length; i++) {
      double timestamp = (DateTime.parse(growthRecordList[i]['date'])).millisecondsSinceEpoch.toDouble();
      if (timestamp < minD){
        minD = timestamp;
      }
      if(timestamp > maxD){
        maxD = timestamp;
      }

      weightPoints.add(FlSpot(timestamp, growthRecordList[i]['weight'].toDouble()));
      heightPoints.add(FlSpot(timestamp, growthRecordList[i]['weight'].toDouble()));
    }
    log(weightPoints.toString());
    log(heightPoints.toString());
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xffffc8c7),
        elevation: 0.0,
        iconTheme : const IconThemeData(color: Colors.black),
        title: const Text('성장 통계', style: TextStyle(color: Colors.black,fontSize: 20)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: TabBar(
              tabs: [
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: const Text('키')
                ),
                Container(
                    height: 35,
                    alignment: Alignment.center,
                    child: const Text('몸무게')
                )
              ],
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              labelColor: const Color(0xffff846d),
              indicatorColor: const Color(0xffff846d),
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                tallChart(),
                TextButton(onPressed: () {

                }, child: const Text('bye')),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
  Widget tallChart(){
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
             FutureBuilder(
               future: getGrowthFuture,
               builder: (context, snapshot) {
                 if (snapshot.hasData == false){
                   return Container(
                       width: double.infinity,
                       child : Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Image.asset('assets/images/baby.png', width: 150),
                           const SizedBox(height: 50),
                           const CircularProgressIndicator(
                             valueColor: AlwaysStoppedAnimation(
                               Colors.white,
                             ),
                           ),
                         ],
                       )
                   );
                 }
                 else if(snapshot.hasError){
                   return Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(
                       'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                       style: const TextStyle(fontSize: 15),
                     ),
                   );
                 }else{

                   return Container(
                     height: 100,
                     child: LineChart(
                         LineChartData(

                           minX: minD,
                           maxX: maxD,
                           minY: 0,
                           maxY: 150,
                           lineBarsData: [
                             LineChartBarData(
                               spots: heightPoints,
                               isCurved: true,
                               gradient: const LinearGradient(
                                 colors: [Colors.pink, Colors.pinkAccent],
                               ),
                               barWidth: 5,
                               isStrokeCapRound: true,
                               dotData:  FlDotData(
                                 show: false,
                               ),
                               belowBarData: BarAreaData(
                                 show: true,
                                 gradient: LinearGradient(
                                   colors: gradientColors
                                       .map((color) => color.withOpacity(0.3))
                                       .toList(),
                                 ),
                               ),
                             ),
                           ],
                         )
                     ),
                   );
                 }
               },
             )
          ],
        ),
      ),
    );
  }
}
