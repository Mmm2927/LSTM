class Login {
  final String token;
  final int loginID;

  Login(this.token, this.loginID);

  Login.fromJson(Map<String, dynamic> json)
      : token = json['token'], loginID = json['loginID'];

  Map<String, dynamic> toJson() => {
    'token': token,
    'loginID': loginID
  };
}