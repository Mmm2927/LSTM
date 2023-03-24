class User {
  final String token;
  final int loginID;
  final String email;   // 유저 이메일
  final String nickname;    // 유저 닉네임


  User(this.token, this.loginID, this.email, this.nickname);

  User.fromJson(Map<dynamic, dynamic> json)
      : token = json['token'], loginID = json['loginID'], email = json['email'], nickname = json['name'];

  Map<String, dynamic> toJson() => {
    'token': token,
    'loginID': loginID,
    'email': email,
    'name': nickname
  };
}