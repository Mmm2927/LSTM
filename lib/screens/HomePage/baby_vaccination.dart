import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';

class BabyVaccination extends StatefulWidget {
  final Baby baby;
  const BabyVaccination(this.baby, {Key? key}) : super(key: key);

  @override
  State<BabyVaccination> createState() => _BabyVaccination();
}

class _BabyVaccination extends State<BabyVaccination> {
  late int currentMode;
  late Map<String, List<Widget>> vaccines1;
  late Map<String, List<Widget>> vaccines2;
  late Map<String, List<Widget>> vaccines3;
  late List<Map<String, List<Widget>>> vaccinesAll;
  @override
  void initState() {
    getVaccinateList();
    // 개월 수에 따라 선택 하도록!
    int duration = (DateTime.now()).difference(widget.baby.birth).inDays ~/ 30;
    if(duration<=6){
      currentMode = 0;
    }else if(12<=duration && duration<=35){
      currentMode = 1;
    }else{
      currentMode = 2;
    }
    super.initState();
  }
  getVaccinateList(){
    // id :
    print(widget.baby.relationInfo.BabyId);
    vaccines1 = {
      '0M':[
        drawVaccineOne('결핵', 'BCG(경피용) - 1회'),
        drawVaccineOne('결핵', 'BCG(피내용) - 1회'),
        drawVaccineOne('B형 간염', 'HepB - 1차'),
      ],
      '1M':[
        drawVaccineOne('B형 간염', 'HepB - 2차'),
      ],
      '2M':[
        drawVaccineOne('B형 간염', 'HepB - 2차'),
      ],
      '4M':[

      ],
      '6M':[

      ]
    };
    vaccines2 = {
      '0':[
        drawVaccineOne('결핵', 'BCG(경피용) - 1회'),
      ],
    };
    vaccines3 = {
      '4세':[
        drawVaccineOne('디프테리아 / 파상풍 / 백일해', 'DTaP - 추5차'),
        drawVaccineOne('폴리오', 'PV - 추4차'),
        drawVaccineOne('홍역 / 유행성 이하선염 / 풍진', 'MMR - 2차'),
      ],
      '6세':[
        drawVaccineOne('디프테리아 / 파상풍 / 백일해', 'DTaP - 추6차'),
        drawVaccineOne('폴리오', 'PV - 추4차'),
        drawVaccineOne('홍역 / 유행성 이하선염 / 풍진', 'MMR - 2차'),
        drawVaccineOne('일본뇌염', 'IJEV(사백신) - 추4차'),
      ],
      '11세':[
        drawVaccineOne('디프테리아 / 파상풍 / 백일해', 'DTaP - 추6차'),
      ],
      '12세':[
        drawVaccineOne('디프테리아 / 파상풍 / 백일해', 'DTaP - 추6차'),
        drawVaccineOne('일본뇌염', 'IJEV(사백신) - 추5차'),
        drawVaccineOne('사람유두종바이러스','HPV2 / HPV4 - 1차'),
        drawVaccineOne('사람유두종바이러스','HPV2 / HPV4 - 2차'),
      ],

    };
    vaccinesAll = [vaccines1, vaccines2, vaccines3];
  }
  /*final List<Vaccine> vaccines = [

    Vaccine(type: '폴리오', content: 'IPV - 1차'),
    Vaccine(type: '폐렴구균', content: 'PCV(단백결합) - 1차'),
    Vaccine(type: '로타바이러스', content: 'RV5 - 1차'),
    Vaccine(type: '디프테리아 / 파상풍 / 백일해', content: 'DTaP - 1차'),
    Vaccine(type: '로타바이러스', content: 'RV1 - 1차'),
    Vaccine(type: '수막구균', content: 'Menveo - 1차'),
    Vaccine(type: 'b형 헤모필루스인플루엔자', content: 'PRP-T / HbOC - 1차'),
    Vaccine(type: '폴리오', content: 'IPV - 2차'),
    Vaccine(type: 'b형 헤모필루스인플루엔자', content: 'PRP-T / HbOC - 2차'),
    Vaccine(type: '수막구균', content: 'Menveo - 2차'),
    Vaccine(type: '로타바이러스', content: 'RV1 - 2차'),
    Vaccine(type: '폐렴구균', content: 'PCV(단백결합) - 2차'),
    Vaccine(type: '디프테리아 / 파상풍 / 백일해', content: 'DTaP - 2차'),
    Vaccine(type: '로타바이러스', content: 'RV5 - 2차'),
    Vaccine(type: '디프테리아 / 파상풍 / 백일해', content: 'DTaP - 3차'),
    Vaccine(type: '수막구균', content: 'Menveo - 3차'),
    Vaccine(type: '로타바이러스', content: 'RV5 - 3차'),
    Vaccine(type: '폴리오', content: 'IPV - 3차'),
    Vaccine(type: 'b형 헤모필루스인플루엔자', content: 'PRP-T / HbOC - 3차'),
    Vaccine(type: '폐렴구균', content: 'PCV(단백결합) - 3차'),
    Vaccine(type: '인플루엔자', content: 'IIV(사백신)'),
    Vaccine(type: 'B형 간염', content: 'HepB - 3차'),
    Vaccine(type: '수막구균', content: 'Menactra - 1차'),
    Vaccine(type: '폐렴구균', content: 'PCV(단백결합) - 추4차'),
    Vaccine(type: 'b형 헤모필루스인플루엔자', content: 'PRP-T / HbOC - 추4차'),
    Vaccine(type: '인플루엔자', content: 'IIV(사백신)'),
    Vaccine(type: '일본뇌염', content: 'IJEV(사백신) - 1차'),
    Vaccine(type: '홍역 / 유행성이하선염 / 풍진', content: 'MMR - 1차'),
    Vaccine(type: '수막구균', content: 'Menveo - 4차'),
    Vaccine(type: '수두', content: 'Var - 1회'),
    Vaccine(type: '수막구균', content: 'Menactra - 2차'),
    Vaccine(type: 'A형 간염', content: 'HepA - 1차'),
    Vaccine(type: '일본뇌염', content: 'LJEV(생백신) - 1차'),
    Vaccine(type: '일본뇌염', content: 'IJEV(사백신) - 2차'),
    Vaccine(type: '디프테리아 / 파상풍 / 백일해', content: 'DTaP - 추4차'),
    Vaccine(type: '수막구균', content: 'Menactra - 3차'),
    Vaccine(type: 'A형 간염', content: 'HepA - 2차'),
    Vaccine(type: '폐렴구균', content: 'PCV(다당질)'),
    Vaccine(type: '인플루엔자', content: 'LAIV(생백신)'),
    Vaccine(type: '일본뇌염', content: 'LJEV(생백신) - 2차'),
    Vaccine(type: '인플루엔자', content: 'IIV(사백신)'),
    Vaccine(type: '일본뇌염', content: 'IJEV(사백신) - 3차'),
    Vaccine(type: '인플루엔자', content: 'LAIV(생백신)'),
    Vaccine(type: '인플루엔자', content: 'LAIV(생백신)'),
    Vaccine(type: '인플루엔자', content: 'IIV(사백신)'),
    Vaccine(type: '인플루엔자', content: 'IIV(사백신)'),
    Vaccine(type: '인플루엔자', content: 'LAIV(생백신)'),
    // Vaccine(type: '홍역 / 유행성이하선염 / 풍진', content: 'MMR - 2차'),
    // Vaccine(type: '폴리오', content: 'PV - 추4차'),
    Vaccine(type: '디프테리아 / 파상풍 / 백일해', content: 'DTaP - 추5차'),
    // Vaccine(type: '일본뇌염', content: 'IJEV(사백신) - 추4차'),
    //Vaccine(type: '디프테리아 / 파상풍 / 백일해', content: 'Td / TdaP - 추6차'),
    Vaccine(type: '사람유두종바이러스', content: 'HPV2 / HPV4 - 1차'),
    Vaccine(type: '일본뇌염', content: 'IJEV(사백신) - 추5차'),
    Vaccine(type: '사람유두종바이러스', content: 'HPV2 / HPV4 - 2차'),
  ];*/

  /*void showPopup() {
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width*0.7,
              height: MediaQuery.of(context).size.height*0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white70
              ),
              child: Column(
                children: vaccines.map((e) =>
                    Row(
                      children: [
                        Text(e.type, style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold,color: Colors.grey),),
                      ],
                    )
                ).toList()
              ),
            ),
          );
        }
        );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffffc8c7),
          elevation: 0.0,
          iconTheme : const IconThemeData(color: Colors.black),
          title: Text('"${widget.baby.name}" 예방 접종', style: TextStyle(color: Colors.black,fontSize: 24)),
        ),
        body: Container(
          color: const Color(0xffffc8c7),
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
              DrawTable()
            ],
          ),
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
        child: Text(title, style: TextStyle(color: (currentMode==mode?Colors.black:Colors.grey),fontSize: 20,fontWeight: (currentMode==mode?FontWeight.bold:FontWeight.normal)))
    );
  }
  Widget drawVaccineOne(String title, String content){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 0.5,color: Colors.grey)
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(25),
      width: double.infinity,
      child: Row(
        children: [
          Image.asset('assets/images/injection.png',scale: 15),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(content)
              ],
            )
          )
        ],
      )
    );
  }
  Widget DrawTable(){
    return Expanded(
        child: ListView.builder(
            itemCount: vaccinesAll[currentMode].keys.length,
            itemBuilder: (BuildContext ctx, int idx){
              String myKey = vaccinesAll[currentMode].keys.toList()[idx];
              return ExpansionTile(
                  title: Text(myKey),
                  children: vaccinesAll[currentMode][myKey]!.toList()
              );
            }
        )
    );
  }
}

