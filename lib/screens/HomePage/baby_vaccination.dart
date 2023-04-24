import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BabyVaccination extends StatefulWidget {
  final String babyname;
  final DateTime babybirth;

  const BabyVaccination(this.babyname, this.babybirth, {Key? key}) : super(key: key);

  @override
  State<BabyVaccination> createState() => _BabyVaccination();
}

class _BabyVaccination extends State<BabyVaccination> {

  late DateTime birth;
  var now = new DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    birth = widget.babybirth;
  }

  final List<Vaccine> vaccines = [
    Vaccine(type: '결핵', content: 'BCG(피내용) - 1회'),
    Vaccine(type: '결핵', content: 'BCG(경피용) - 1회'),
    Vaccine(type: 'B형 간염', content: 'HepB - 1차'),
    Vaccine(type: 'B형 간염', content: 'HepB - 2차'),
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
    Vaccine(type: '홍역 / 유행성이하선염 / 풍진', content: 'MMR - 2차'),
    Vaccine(type: '폴리오', content: 'PV - 추4차'),
    Vaccine(type: '디프테리아 / 파상풍 / 백일해', content: 'DTaP - 추5차'),
    Vaccine(type: '일본뇌염', content: 'IJEV(사백신) - 추4차'),
    Vaccine(type: '디프테리아 / 파상풍 / 백일해', content: 'Td / TdaP - 추6차'),
    Vaccine(type: '사람유두종바이러스', content: 'HPV2 / HPV4 - 1차'),
    Vaccine(type: '일본뇌염', content: 'IJEV(사백신) - 추5차'),
    Vaccine(type: '사람유두종바이러스', content: 'HPV2 / HPV4 - 2차'),
  ];

  void showPopup() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffc8c7),
        elevation: 0.0,
        iconTheme : const IconThemeData(color: Colors.black),
        title: Text('"${widget.babyname}" 예방 접종', style: TextStyle(color: Colors.black,fontSize: 24)),
      ),
      body: Container(
        color: Color(0xffffc8c7),
        child: ListView(
          children: vaccines.map((e) =>
          Card(
            color: Colors.grey[100],
            child: ListTile(
              leading: Icon(Icons.vaccines_outlined, size: 35,color: Colors.orangeAccent,),
              title: Text(e.type,style: TextStyle(fontSize: 26),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.content, style: TextStyle(fontSize: 20),),
                  // Text('${widget.babybirth}', style: TextStyle(fontSize: 20),)
                  Text('권장일 : '+DateFormat('yyyy.M.dd').format(widget.babybirth), style: TextStyle(fontSize: 15),)
                ],
              ),
              isThreeLine: true,
              trailing: Icon(Icons.info),
              onTap: (){
                showPopup();
              },
            ),
          )
          ).toList(),
        ),
      )
    );
  }
}

class Vaccine {
  final String type;
  final String content;

  Vaccine({required this.type, required this.content});
}
