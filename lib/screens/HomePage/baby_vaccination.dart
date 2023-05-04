import 'package:bob/services/storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';
import 'package:bob/services/backend.dart';
import 'package:get/get.dart';

class BabyVaccination extends StatefulWidget {
  final Baby baby;
  const BabyVaccination(this.baby, {Key? key}) : super(key: key);
  @override
  State<BabyVaccination> createState() => _BabyVaccination();
}

class _BabyVaccination extends State<BabyVaccination> {
  late List<Vaccine> vaccines;
  late Future getMyVaccineFuture;
  late int currentMode;
  late Map<String, List<Widget>> vaccines1;
  late Map<String, List<Widget>> vaccines2;
  late Map<String, List<Widget>> vaccines3;
  late List<Map<String, List<Widget>>> vaccinesAll;
  @override
  void initState() {
    vaccines = [
      Vaccine(ID: 0, title: '결핵 경피용', times: 'BCG 1회/기타', recommendationDate: '2023.01.20 ~ 2023.02.19', detail: '생후 4주 이내 접종, 민간의료기관, 유료'),
      Vaccine(ID: 1, title: '결핵 피내용', times: 'BCG 1회/기타', recommendationDate: '2023.01.20 ~ 2023.02.19', detail: '생후 4주 이내 접종, 민간의료기관, 유료'),
      Vaccine(ID: 2, title: 'B형 간염', times: 'HepB 1차/국가', recommendationDate: '2023.01.20', detail: '생후 12시간 이내 접종(모체가 양성일 경우 HBIG와 함께 접종)'), // 2
      Vaccine(ID: 3, title: 'B형 간염', times: 'HepB 2차/국가', recommendationDate: '2023.02.20', detail: '만 1개월에 접종'),
      Vaccine(ID: 4, title: '디프테리아, 파상풍, 백일해', times: 'DTaP 1회/국가', recommendationDate: '2023.03.20', detail: 'DTaP-IPV 폴리오와 혼합 접종 가능'),
      Vaccine(ID: 5, title: '폴리오', times: 'IPV 1회/국가', recommendationDate: '2023.03.20', detail: 'DTaP-IPV 혼합 접종 가능'),
      Vaccine(ID: 6, title: 'b형 헤모필루스인플루엔자', times: 'Hib 1차/국가', recommendationDate: '2023.03.20', detail: '뇌수막염 예방접종'),
      Vaccine(ID: 7, title: '폐렴구균', times: 'PCV(단백결합) 1차/국가', recommendationDate: '2023.03.20', detail: ''),
      Vaccine(ID: 8, title: '로타바이러스(로타릭스)', times: 'RV1 1차/기타', recommendationDate: '2023.03.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 9, title: '로타바이러스(로타텍)', times: 'RV5 1차/기타', recommendationDate: '2023.03.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 10, title: '디프테리아, 파상풍, 백일해', times: 'DTaP 2차/국가', recommendationDate: '2023.05.20', detail: 'DTaP-IPV 폴리오와 혼합 접종 가능'),
      Vaccine(ID: 11, title: '폴리오', times: 'IPV 2차/국가', recommendationDate: '2023.05.20', detail: 'DTaP-IPV 혼합 접종 가능'),
      Vaccine(ID: 12, title: 'b형 헤모필루스인플루엔자', times: 'Hib 2차/국가', recommendationDate: '2023.05.20', detail: '뇌수막염 예방접종, 만 4개월에 접종'),
      Vaccine(ID: 13, title: '폐렴구균', times: 'PCV(단백결합) 2차/국가', recommendationDate: '2023.05.20', detail: '만 4개월에 접종'),
      Vaccine(ID: 14, title: '로타바이러스(로타릭스)', times: 'RV1 2차/기타', recommendationDate: '2023.05.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 15, title: '로타바이러스(로타텍)', times: 'RV5 2차/기타', recommendationDate: '2023.05.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 16, title: 'B형 간염', times: 'HepB 3차/국가', recommendationDate: '2023.07.20', detail: '만 6개월에 접종'),
      Vaccine(ID: 17, title: '디프테리아, 파상풍, 백일해', times: 'DTaP 3차/국가', recommendationDate: '2023.07.20', detail: 'DTaP-IPV 폴리오와 혼합 접종 가능'),
      Vaccine(ID: 18, title: '폴리오', times: 'IPV 3차/국가', recommendationDate: '2023.07.20', detail: 'DTaP-IPV 혼합 접종 가능'),
      Vaccine(ID: 19, title: 'b형 헤모필루스인플루엔자', times: 'Hib 3차/국가', recommendationDate: '2023.07.20', detail: '뇌수막염 예방접종, 만 6개월에 접종'),
      Vaccine(ID: 20,title: '폐렴구균', times: 'PCV(단백결합) 3차/국가', recommendationDate: '2023.07.20', detail: '만 6개월에 접종'),
      Vaccine(ID: 21,title: '로타바이러스(로타텍)', times: 'RV5 3차/기타', recommendationDate: '2023.07.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 22,title: '인플루엔자', times: 'IIV 1차/국가', recommendationDate: '2023.07.20 ~ 2023.08.19', detail: '만 6개월 후 지정기간에서 접종\n생애 최초 시 4주 후 2차 접종'),
      Vaccine(ID: 23,title: '인플루엔자', times: 'IIV 2차/국가', recommendationDate: '2023.07.20 ~ 2023.08.19', detail: '만 6개월 후 지정기간에서 접종\n생애 최초 시 4주 후 2차 접종'),
      Vaccine(ID: 24,title: 'b형 헤모필루스인플루엔자', times: 'Hib 추가 4차/국가', recommendationDate: '2024.01.20 ~ 2024.05.19', detail: '뇌수막염 접종, 만 12~15개월에 접종'),
      Vaccine(ID: 25,title: '폐렴구균', times: 'PCV(단백결합) 추가 4차/국가', recommendationDate: '2024.01.20 ~ 2024.05.19', detail: '만 12~15세 접종'),
      Vaccine(ID: 26,title: '홍역, 유행성이하선염, 풍진', times: 'MMR 1차/국가', recommendationDate: '2024.01.20 ~ 2024.05.19', detail: '만 12~15세 접종'),
      Vaccine(ID: 27,title: '수두', times: 'VAR 1회/국가', recommendationDate: '2024.01.20 ~ 2024.05.19', detail: '만 12~15세 접종'),
      Vaccine(ID: 28,title: '디프테리아 / 파상풍 / 백일해', times: 'DTaP 추가 4차/국가', recommendationDate: '2024.04.20 ~ 2024.08.19', detail: '만 15~18세 접종'),
      Vaccine(ID: 29,title: 'A형 간염', times: 'HepA 1차/국가', recommendationDate: '2024.01.20 ~ 2024.12.19', detail: '만 12~23세 접종'),
      Vaccine(ID: 30, title: 'A형 간염', times: 'HepA 2차/국가', recommendationDate: '2024.01.20 ~ 2024.12.19', detail: '만 12~23세 접종'),
      Vaccine(ID: 31, title: '일본뇌염 사백신', times: 'IJEV 1차/국가', recommendationDate: '2024.01.20 ~ 2024.12.19', detail: '사백신 총 5회 접종'),
      Vaccine(ID: 32, title: '일본뇌염 사백신', times: 'IJEV 2차/국가', recommendationDate: '2024.01.20 ~ 2024.12.19', detail: '1차 접종 1개월 후 접종'),
      Vaccine(ID: 33, title: '일본뇌염 사백신', times: 'IJEV 3차/국가', recommendationDate: '2025.12.20 ~ 2027.01.19', detail: '2차 접종 11개월 후 접종'),
      Vaccine(ID: 34, title: '일본뇌염 생백신', times: 'LJEV 1차/국가', recommendationDate: '2024.01.20 ~ 2025.12.19', detail: '총 2회 접종, 1차 접종 12개월 후 2차 접종(무료/유료)'),
      Vaccine(ID: 35, title: '일본뇌염 생백신', times: 'LJEV 2차/국가', recommendationDate: '2024.01.20 ~ 2025.12.19', detail: '총 2회 접종, 1차 접종 12개월 후 2차 접종(무료/유료)'),
      Vaccine(ID: 36, title: '인플루엔자', times: 'IIV 1회/국가', recommendationDate: '2024.12.20 ~ 2025.12.19', detail: '국가지정기간에서 접종(보통 10월중순 즘 시작)'),
      Vaccine(ID: 37, title: '인플루엔자', times: 'IIV 2회/국가', recommendationDate: '2025.12.20 ~ 2027.12.19', detail: '국가지정기간에서 접종(보통 10월중순 즘 시작)'),
      Vaccine(ID: 38, title: '디프테리아 / 파상풍 / 백일해', times: 'DTaP 추가 5차/국가', recommendationDate: '2027.01.20 ~ 2030.01.19', detail: '만 4~6세 접종'),
      Vaccine(ID: 39, title: '디프테리아 / 파상풍 / 백일해', times: 'DTaP 추가 6차/국가', recommendationDate: '2034.01.20 ~ 2036.01.19', detail: '만 11~12세 접종'),
      Vaccine(ID: 40, title: '폴리오', times: 'IPV 추가 4차/국가', recommendationDate: '2027.01.20 ~ 2030.01.19', detail: '만 4~6세 접종'),
      Vaccine(ID: 41, title: '홍역 / 유행성 이하선염 / 풍진', times: 'MMR 2차/국가', recommendationDate: '2027.01.20 ~ 2030.01.19', detail: '만 4~6세 접종'),
      Vaccine(ID: 42, title: '일본뇌염 사백신', times: 'IJEV(사백신) 추가 4차/국가', recommendationDate: '2029.01.20', detail: '총 5회 접종, 4차 접종'),
      Vaccine(ID: 43, title: '일본뇌염 사백신', times: 'IJEV(사백신) 추가 5차/국가', recommendationDate: '2035.01.20', detail: '총 5회 접종, 5차 접종'),
      Vaccine(ID: 44, title: '인유두종 바이러스 감염증', times: 'HPV 1차/국가', recommendationDate: '2035.01.20 ~ 2036.01.19', detail: '자궁경부암백신, 여아만 해당\n만 12세에 6개월 간격으로 2회 접종')
    ];
    //DrawVaccinateList();
    getMyVaccineFuture = getMyVaccineInfo();
    // 개월 수에 따라 선택 하도록!
    int duration = (DateTime.now()).difference(widget.baby.birth).inDays ~/ 30;
    if(duration <= 6){
      currentMode = 0;
    }else if(12 <= duration && duration <= 35){
      currentMode = 1;
    }else{
      currentMode = 2;
    }
    super.initState();
  }
  DrawVaccinateList(){
    vaccines1 = {
      '0M': drawMonthVaccines([0,1,2]),
      '1M': drawMonthVaccines([2]),
      '2M': drawMonthVaccines([4,5,6,7,8,9]),
      '4M': drawMonthVaccines([10,11,12,13,14,15]),
      '6M': drawMonthVaccines([16,17,18,19,20,21,22,23]),
    };
    vaccines2 = {
      '12M' : drawMonthVaccines([24, 25, 26, 27, 29,30, 31, 32, 34,35]),
      '15M' : drawMonthVaccines([24, 25, 26, 27, 28, 29,30, 31, 32, 34,35]),
      '18M' : drawMonthVaccines([28, 29, 30, 31, 32,34,35]),
      '23M' : drawMonthVaccines([29, 30, 31, 32, 34,35,36]),
      '35M' : drawMonthVaccines([33, 34,35,37]),
    };
    vaccines3 = {
      '4세' : drawMonthVaccines([38, 40, 41]),
      '6세' : drawMonthVaccines([38, 40, 41, 42]),
      '11세': drawMonthVaccines([39]),
      '12세': drawMonthVaccines([39,43,44]),
    };
    vaccinesAll = [vaccines1, vaccines2, vaccines3];
  }
  List<Widget> drawMonthVaccines(List<int> nums){
    List<Widget> tmp = [];
    for(int i=0; i<nums.length; i++){
      tmp.add(drawVaccineOne(vaccines[nums[i]]));
    }
    return tmp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme : const IconThemeData(color: Colors.black),
          title: Text('"${widget.baby.name}" 예방 접종', style: TextStyle(color: Colors.black,fontSize: 24)),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.error_outline),
                  SizedBox(width: 10,),
                  Text('만 12세까지 접종')
                ],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      chooseDate('0~6개월', 0),
                      chooseDate('12~35개월', 1),
                      chooseDate('만 4~12세', 2),
                    ],
                  )
              ),
              FutureBuilder(
                  future: getMyVaccineFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if (snapshot.hasData == false) {
                      return const CircularProgressIndicator(color: Colors.pinkAccent);
                    }
                    else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      );
                    }
                    else {
                      DrawVaccinateList();
                      return Expanded(
                          child: ListView.builder(
                              itemCount: vaccinesAll[currentMode].keys.length,
                              itemBuilder: (BuildContext ctx, int idx){
                                String myKey = vaccinesAll[currentMode].keys.toList()[idx];
                                return ExpansionTile(
                                    initiallyExpanded: true,
                                    title: Text(myKey, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    children: vaccinesAll[currentMode][myKey]!.toList()
                                );
                              }
                          )
                      );
                    }
                  }
              ),
              const SizedBox(height: 5),
              Row(
                children: const [
                  Icon(Icons.error_outline),
                  SizedBox(width: 10,),
                  Text('기준 : 질병관리청 표준 예방접종 일정표'),
                ],
              ),
            ],
          ),
        )
    );
  }
  void openDialog(Vaccine vaccine){
    List<bool> isSelected = [true, false];
    Get.dialog(
      StatefulBuilder(
          builder: (BuildContext Mcontext, StateSetter setState){
            return AlertDialog(
              content: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Text(vaccine.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(vaccine.times, style: TextStyle(fontSize: 18)),
                    Text(vaccine.detail, style: TextStyle(fontSize: 14)),
                    Text('권장시기 : ${vaccine.recommendationDate}', style: TextStyle(fontSize: 14)),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                        child: Container(
                          width: double.infinity,
                          child: ToggleButtons(
                            constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 36) / 3, maxHeight: 80),
                            direction: Axis.horizontal,
                            onPressed: (int val){
                              setState(() {
                                isSelected = [(val==0), (val==1)];
                              });
                            },
                            isSelected: isSelected,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/injection.png',scale: 15),
                                      const SizedBox(height: 5,),
                                      const Text('미접종', style: TextStyle(color: Colors.grey),)
                                    ],
                                  )
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/injection.png',scale: 15,color: Colors.blue),
                                      const SizedBox(height: 5,),
                                      const Text('접종', style: TextStyle(color: Colors.blue))
                                    ],
                                  )
                              )
                            ],
                          )
                        )
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xffffc8c7),
                          ),
                          onPressed: (){
                            if(isSelected[1]){
                              setVaccineInfo(vaccine.ID,'${vaccine.title}(${vaccine.times})', 'y');
                            }
                            Get.back();
                          },
                          child: const Text('확인')
                      )
                    )
                  ],
                )
              )
            );
          }
      )
    );
  }
  Widget chooseDate(String title, int mode){
    return TextButton(
        onPressed: (){
          setState(() {
            currentMode = mode;
          });
        },
        child: Text(
            title,
            style: TextStyle(
                color: (currentMode==mode?Colors.black:Colors.grey),
                fontSize: 20,
                fontWeight: (currentMode==mode?FontWeight.bold:FontWeight.normal)
            )
        )
    );
  }
  Widget drawVaccineOne(Vaccine vaccine){
    if(vaccine.isInoculation){
      return Container(
          decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 0.5,color: Colors.pinkAccent)
          ),
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(25),
          width: double.infinity,
          child: Row(
            children: [
              Column(
                children: [
                  Image.asset('assets/images/injection.png',scale: 15, color: Colors.pinkAccent),
                  const SizedBox(height: 5),
                  const Text('접종완료', style: TextStyle(color: Colors.pinkAccent))
                ],
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vaccine.title,style: TextStyle(color:Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(vaccine.times),
                          Text('접종일 : ${DateFormat.yMMMd().format(vaccine.inoculationDate)}')
                        ],
                      )
                  )
              )
            ],
          )
      );
    }
    else{
      return InkWell(
          onTap: (){
            openDialog(vaccine);
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 0.5,color: Colors.grey)
              ),
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(25),
              width: double.infinity,
              child: Row(
                children: [
                  Column(
                    children: [
                      Image.asset('assets/images/injection.png',scale: 15),
                      const SizedBox(height: 5),
                      const Text('접종 전'),
                    ],
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vaccine.title,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(vaccine.times),
                              Text('접종권장일 : ${vaccine.recommendationDate}')
                            ],
                          )
                      )
                  )
                ],
              )
          )
      );
    }
  }

  // 예방접종 set 메소드(API 연결)
  setVaccineInfo(int mode, String checkName, String state) async{
    var result = await vaccineSetService(widget.baby.relationInfo.BabyId, checkName, mode, state);
    if(result['result'] == 'success'){
      Get.snackbar('예방접종 완료', '$checkName 접종을 작성하였습니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      setState(() {
        getMyVaccineFuture = getMyVaccineInfo();
      });
    }
  }
  Future getMyVaccineInfo() async{
    // 0. 우선 전처리 하기
    List<dynamic> vaccineList = await vaccineCheckByIdService(widget.baby.relationInfo.BabyId);
    // 1. mode(=ID)를 찾아 접종된 거는 처리
    for(int i=0; i<vaccineList.length; i++){
      int mode = vaccineList[i]['mode'];
      // 예외 처리
      if(mode>44) continue;
      vaccines[mode].isInoculation = true;
      vaccines[mode].inoculationDate = DateTime.parse(vaccineList[i]['date']);
    }
    return true;
  }
}