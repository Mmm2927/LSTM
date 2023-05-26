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

  late TabController _tabController;
  late Future getGrowthFuture;
  bool showAvg = false;
  var babyheight = [];
  var babyweight = [];
  var growthdate = [];


  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(
        length: 2,
        vsync: this,
    );
    super.initState();
    print(widget.baby.relationInfo.BabyId);
    getGrowthFuture = getMyGrowthInfo();
  }

  Future getMyGrowthInfo() async{

    List<dynamic> growthRecordList = await growthGetService(widget.baby.relationInfo.BabyId);
    print(growthRecordList);
    for(int i=0; i<growthRecordList.length; i++) {
      babyheight.add(growthRecordList[i]['height']);
      babyweight.add(growthRecordList[i]['weight']);
      growthdate.add(growthRecordList[i]['date']);
    }
    print(babyheight);
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xffffc8c7),
        elevation: 0.0,
        iconTheme : IconThemeData(color: Colors.black),
        title: Text('성장 통계', style: TextStyle(color: Colors.black,fontSize: 20)),
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

                }, child: Text('bye')),
              ],
            ),
          ),
        ],
      ),
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
                       decoration: const BoxDecoration(
                         color: Color(0xfffa625f),
                       ),
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
                     child: LineChart(
                       LineChartData(
                           lineBarsData:[
                             LineChartBarData(
                               spots: [
                                 FlSpot(0, 3.44),
                                 FlSpot(2.6, 3.44),
                                 FlSpot(4.9, 3.44),
                                 FlSpot(6.8, 3.44),
                                 FlSpot(8, 3.44),
                                 FlSpot(9.5, 3.44),
                                 FlSpot(11, 3.44),
                               ]
                             )
                           ]
                   ),
                 swapAnimationDuration: Duration(milliseconds: 150), // Optional
                 swapAnimationCurve: Curves.linear, // Optional
                 )
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
