import 'dart:convert';

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
}

class Login {
  final String token;
  final int loginID;
  final User userInfo;

  Login(this.token, this.loginID, this.userInfo);

  Login.fromJson(Map<dynamic, dynamic> json)
      : token = json['token'], loginID = json['loginID'], userInfo = User.fromJson(json['userInfo']);

  Map<String, dynamic> toJson() => {
    'token': token,
    'loginID': loginID,
    'userInfo': userInfo
  };
}

class Baby_relation{
  final int BabyId;
  final int relation; // 0:부모, 1: 가족 , 2 : 베이비시터
  final int Access_week;
  final String Access_startTime;
  final String Access_endTime;

  String getRelationString(){
    if(relation==0) return '부모';
    if(relation==1) return '가족';
    else return '베이비시터';
  }
  Baby_relation(this.BabyId, this.relation, this.Access_week, this.Access_startTime, this.Access_endTime);
  Baby_relation.fromJson(Map<dynamic, dynamic> json)
      : BabyId = json['BabyId'], relation = json['relation'], Access_week = json['Access_week'], Access_startTime = json['Access_startTime'], Access_endTime = json['Access_endTime'];
  Map<String, dynamic> toJson() => {
    'BabyId': BabyId,
    'relation': relation,
    'Access_week': Access_week,
    'Access_startTime': Access_startTime,
    'Access_endTime': Access_endTime,
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
      : name = json['name'], birth = json['birth'], gender = json['gender'], relationInfo = Baby_relation.fromJson(json['relationInfo']);
  getGenderString(){
    if(gender==0) return '여아';
    if(gender==1) return '남아';
  }
  Map<String, dynamic> toJson() => {
    'name': name,
    'birth': birth,
    'gender': gender,
    'relationInfo': relationInfo
  };
}
