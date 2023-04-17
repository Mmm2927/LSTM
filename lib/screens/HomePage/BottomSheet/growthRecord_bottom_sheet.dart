import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_picker/horizontal_picker.dart';

import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import '../../../services/backend.dart';

class GrowthRecordBottomSheet extends StatefulWidget {

  final int babyId;
  // final void Function(String id) timeFeedingBottle;

  const GrowthRecordBottomSheet (this.babyId, {Key? key}) : super(key: key);
  //final String feedingTime;

  @override
  _GrowthRecordBottomSheet createState() => _GrowthRecordBottomSheet();
}

class _GrowthRecordBottomSheet extends State<GrowthRecordBottomSheet> {


  double? height;
  double? weight;

  DateTime _selectedDate = DateTime.now();

  GlobalKey<FormState> _fKey = GlobalKey<FormState>();
  String? yearMonthDayTime;
  TextEditingController ymdtController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.62,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 25, top: 5),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('키, 몸무게',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HorizontalPicker(
                      minValue: 0,
                      maxValue: 100,
                      divisions: 1000,
                      height: 100,
                      suffix: " cm",
                      showCursor: false,
                      backgroundColor: Colors.transparent,
                      activeItemTextColor: Colors.black,
                      passiveItemsTextColor: Colors.red,
                      onChanged: (value) {
                        setState(() {
                          height = value;
                        });
                      },
                    ),
                    (height==null) ? Text('스크롤하여 키를 선택해 주세요',style: TextStyle(fontSize: 22, color: Colors.grey)) :
                    Text('${height.toString()} cm',style: TextStyle(fontSize: 22),),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Divider(),
                    HorizontalPicker(
                      minValue: 0,
                      maxValue: 20,
                      divisions: 200,
                      height: 100,
                      suffix: " kg",
                      showCursor: false,
                      backgroundColor: Colors.transparent,
                      activeItemTextColor: Colors.black,
                      passiveItemsTextColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          weight = value;
                        });
                      },
                    ),
                    (weight==null) ? Text('스크롤하여 몸무게를 선택해 주세요',style: TextStyle(fontSize: 22, color: Colors.grey)) :
                    Text('${weight.toString()} kg',style: TextStyle(fontSize: 22),),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    var datePicked = await DatePicker.showSimpleDatePicker(
                      context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2040),
                      dateFormat: "yyyy-MMMM-dd",
                      locale: DateTimePickerLocale.ko,
                      looping: true,
                      backgroundColor: Colors.purple[50],
                      titleText: '측정 날짜를 선택해주세요',
                      cancelText: '취소',
                      confirmText: '확인',
                      itemTextStyle: TextStyle(color: Colors.orange),
                      textColor: Colors.black
                    );

                    ymdtController.text = '${DateFormat('yyyy년 MM월 dd일').format(datePicked!)}';

                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: ymdtController,
                        decoration: const InputDecoration(
                            labelText: '측정 날짜를 선택해주세요',
                            labelStyle: TextStyle(fontSize: 18),
                            suffixIcon: Icon(Icons.add_alarm_sharp),
                            filled: false, //색 지정
                            enabledBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.orangeAccent)
                            ),
                            contentPadding: EdgeInsets.all(10)
                        ),
                        onSaved: (val) {
                          yearMonthDayTime = ymdtController.text;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Year-Month-Date is necessary';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('취소',style: TextStyle(fontSize: 25),),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          minimumSize: Size((MediaQuery.of(context).size.width)/2*0.8, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          )
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async{  // 추가할 예정
                        // print(widget.babyId);
                        // int type = isSelect? 0 : 1;   // 0:모유, 1:분유
                        // String amount = amountController.text;
                        // String startTime = dateTimeList![0].toString();
                        // String endTime = dateTimeList![1].toString();
                        // String memo = memoController.text;
                        //
                        // var content = {"type": type, "amount": amount, "startTime": startTime, "endTime": endTime, "memo": memo,};
                        // var result = await lifesetService(widget.babyId, 1, content.toString());
                        //
                        // String feedingBottleTime = '${DateTime.now().difference(dateTimeList![1]).inMinutes}분 전';
                        // widget.timeFeedingBottle(feedingBottleTime);
                        Navigator.pop(context);
                      },
                      child: Text('확인',style: TextStyle(fontSize: 25),),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          minimumSize: Size((MediaQuery.of(context).size.width)/2*0.8, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          side: BorderSide(
                            color: Colors.orangeAccent,
                          )
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}