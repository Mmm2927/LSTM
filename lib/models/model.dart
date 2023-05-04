import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

class User {
  late final String email;
  late String password1;
  late String name;
  late String phone;
  User(this.email, this.password1, this.name, this.phone);

  User.fromJson(Map<dynamic, dynamic> json)
      : email = json['email'], password1 = json['password1'], name = json['name'], phone = json['phone'];

  Map<String, dynamic> toJson() => {
    "email": email,
    "password1": password1,
    "name": name,
    "phone": phone
  };
  modifyUserInfo(_pass, _name, _phone){
    this.password1 = _pass;
    this.name = _name;
    this.phone = _phone;
  }
}
class Login {
  final String token;
  final String refreshtoken;
  final int loginID;
  final String userEmail;
  String userPassword;
  Login(this.token, this.refreshtoken, this.loginID, this.userEmail, this.userPassword);
  changePassword(String newPass){
    this.userPassword = newPass;
  }
  Login.fromJson(Map<dynamic, dynamic> json)
      : token = json['token'],
        refreshtoken = json['refreshtoken'],
        loginID = json['loginID'],
        userEmail = json['userEmail'],
        userPassword = json['userPassword'];

  Map<String, dynamic> toJson() => {
    'token': token,
    'refreshtoken': refreshtoken,
    'loginID': loginID,
    'userEmail': userEmail,
    'userPassword': userPassword,
  };
}
class Baby_relation{
  final int BabyId;
  final int relation; // 0:부모, 1: 가족 , 2 : 베이비시터
  final int Access_week;
  final String Access_startTime;
  final String Access_endTime;
  final bool active;

  String getRelationString(){
    if(relation==0) return '부모';
    if(relation==1) return '가족';
    else return '베이비시터';
  }
  Baby_relation(this.BabyId, this.relation, this.Access_week, this.Access_startTime, this.Access_endTime, this.active);
  Baby_relation.fromJson(Map<dynamic, dynamic> json)
      : BabyId = json['baby'],
        relation = json['relation'],
        Access_week = (json['access_date']==null) ? 255 : json['access_date'],
        Access_startTime = (json['access_starttime']==null) ? "" : json['access_starttime'],
        Access_endTime = (json['access_endtime']==null) ? "" : json['access_endtime'],
        active=json['active'];

  Map<String, dynamic> toJson() => {
    'baby': BabyId,
    'relation': relation,
    'access_date': Access_week,
    'access_starttime': Access_startTime,
    'access_endtime': Access_endTime,
    'active': active,
  };

  void elif(bool bool) {}
}
class Baby {
  final String name;
  final DateTime birth;
  final int gender; // 0 : 'F', 1 : 'M'
  final Baby_relation relationInfo;

  Baby(this.name, this.birth, this.gender, this.relationInfo);

  Baby.fromJson(Map<dynamic, dynamic> json)
      : name = json['baby_name'], birth = DateTime.parse(json['birth']), gender = (json['gender']=='M'?0:1), relationInfo = Baby_relation.fromJson(json['relationInfo']);
  getGenderString(){
    if(gender==0) return 'F';
    if(gender==1) return 'M';
  }

  Map<String, dynamic> toJson() => {
    'baby_name': name,
    'birth': birth,
    'gender': gender,
    'relationInfo': relationInfo
  };
}

class lifeRecord{
  final int babyId;
  final int mode;   // 0:수유, 1:젖병 2:이유식 3:기저귀 4:수면
  final String content;
  lifeRecord(this.babyId, this.mode, this.content);
  makeContent(mode, extra, sTime, eTime, memo){
    var data;
    if(mode==0) {
      data = {"side": extra[0], "startTime": sTime, "endTime": eTime, "memo": memo};
    }else if(mode ==1){
      data = {"type":extra[0], "amount":extra[1], "memo": memo, "startTime":sTime, "endTime":eTime};
    }else if(mode ==2){
      data = {"amount":extra[0], "startTime":sTime, "endTime":eTime, "memo": memo};
    }else if(mode ==3){
      data = {"type": extra[0], "startTime":sTime, "endTime":eTime, "memo": memo};
    }else if(mode ==4){
      data = {"startTime":sTime, "endTime":eTime, "memo": memo};
    }
  }
}

class growthRecord{
  final int babyId;
  final double height;
  final double weight;
  final DateTime date;
  growthRecord(this.babyId, this.height, this.weight, this.date);

  growthRecord.fromJson(Map<dynamic, dynamic> json)
      : babyId = json['babyId'], height = json['height'], weight = json['weight'], date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() => {
    "babyId": babyId,
    "height": height,
    "weight": weight,
    "date": date
  };
}
class Vaccine {
  final int ID;
  final String title;    // 타이틀
  final String times;   // 몇회
  final String recommendationDate;  // 권장 시기
  final String detail;   // 내용
  late DateTime inoculationDate;    // 접종 날짜
  late bool isInoculation = false;    // 접종 여부
  Vaccine({required this.ID, required this.title, required this.times, required this.recommendationDate, required this.detail});
}
class MedicalCheckUp {
  final int ID;
  final String title;    // 타이틀
  final List<int> checkTiming;   // 검진 시기
  late String checkPeriod;   // 검진 기간
  late DateTime checkUpDate;    // 검진 완료일
  late bool isInoculation = false;    // 접종 여부

  MedicalCheckUp(this.ID, this.title, this.checkTiming, DateTime birth){
    if(checkTiming[0] == 1){
      checkPeriod = '${DateFormat('yyyy.MM.dd').format(DateTime(birth.year, birth.month, birth.day + checkTiming[1]))} ~ ${DateFormat('yyyy.MM.dd').format(DateTime(birth.year, birth.month, birth.day + checkTiming[2]))}';
    }else{
      checkPeriod = '${DateFormat('yyyy.MM.dd').format(DateTime(birth.year, birth.month + checkTiming[1], birth.day))} ~ ${DateFormat('yyyy.MM.dd').format(DateTime(birth.year, birth.month + checkTiming[2], birth.day))}';
    }
  }
  String checkTimingToString(){
    return '생후 ${checkTiming[1]}~${checkTiming[2]}${checkTiming[0]==0?'개월':'일'}';
  }
  String drawDateString(){
    return '${checkPeriod.substring(0,4)}년 ${checkPeriod.substring(5,7)}월';
   }
}