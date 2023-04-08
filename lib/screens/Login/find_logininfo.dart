import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
class FindLogInfo extends StatefulWidget{
  final int _mode;
  const FindLogInfo(this._mode, {super.key});
  @override
  State<FindLogInfo> createState() => _FindLogInfo();
}
class _FindLogInfo  extends State<FindLogInfo> with TickerProviderStateMixin{
  late TextEditingController pass_idController;
  late TextEditingController pass_nameController;
  late TextEditingController id_phnoeController;
  late TextEditingController id_nameController;
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
        initialIndex: widget._mode,
        length: 2,
        vsync: this
    );
    pass_idController = TextEditingController();
    pass_nameController = TextEditingController();
    id_phnoeController = TextEditingController();
    id_nameController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppbar('로그인 정보 찾기', true),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              child: TabBar(
                tabs: [
                  Container(
                      height: 35,
                      alignment: Alignment.center,
                      child: const Text('로그인 찾기')
                  ),
                  Container(
                      height: 35,
                      alignment: Alignment.center,
                      child: const Text('비밀번호 찾기')
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
                    findId(),
                    findPassword()
                  ],
                )
            )
          ],
        )
    );
  }
  CupertinoTextField drawForm(String title, TextEditingController controller){
    return  CupertinoTextField(
      controller: controller,
      placeholder: title,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.5)
      ),
      onChanged: (text){
        setState(() {});
      },
    );
  }
  Container findId(){
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            drawForm('닉네임을 입력해주세요',id_nameController),
            const SizedBox(height: 15),
            drawForm('핸드폰 번호를 입력해주세요',id_phnoeController),
            const SizedBox(height: 30),
            CupertinoButton(
                color:Colors.black,
                borderRadius: BorderRadius.circular(12),
                onPressed: _isValid(true)? _getId : null,
                child: const Text('아이디 찾기')
            )
          ],
        )
    );
  }
  Container findPassword(){
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            drawForm('이메일을 입력해주세요',pass_idController),
            const SizedBox(height: 15),
            drawForm('닉네임을 입력해주세요',pass_nameController),
            const SizedBox(height: 30),
            CupertinoButton(
                color:Colors.black,
                borderRadius: BorderRadius.circular(12),
                onPressed: _isValid(false)? _getPassword : null,
                child: const Text('비밀번호 찾기')
            ),
          ],
        )
    );
  }
  bool _isValid(bool isId){
    if(isId) {
      return (id_nameController.text.length>=4 && id_phnoeController.text.length==11);
    } else {
      return (pass_idController.text.length>=4
          && pass_nameController.text.length >=4
          && RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(pass_idController.text.trim())
      );
    }
  }

  void _show_result_Dialog(String title, String contentTitle, String contentVal){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: Text(title),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Icon(Icons.account_balance_rounded),
                    const SizedBox(height: 30),
                    Text(contentTitle,style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 20),
                    Text(contentVal)
                  ]
              ),
              actions: [
                TextButton(onPressed: ()=> Navigator.of(context).pop(),
                    child: const Text('확인', style: TextStyle(color: Colors.red))
                )
              ]
          );
        });
  }
  void _getId() async{
    // 1. response <- 에 아이디 받기
    String result = '38231@naver.com';
    if(result.length>0){
      _show_result_Dialog('아이디 조회 결과','고객님의 아이디 찾기가 완료되었습니다.','아이디 : 38231@naver.com');
    }
    else{
      _showDialog('해당 유저는 존재하지 않습니다', context);
    }
    id_nameController.clear();
    id_phnoeController.clear();
  }
  void _getPassword() async{
    // 1. validate
    String id = pass_idController.text;
    if(!RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(id.trim())){
      _showDialog("올바른 ID 형식이 아닙니다",context);
      pass_idController.clear();
      pass_nameController.clear();
      return;
    }
    // 2. find password

  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    pass_idController.dispose();
    pass_nameController.dispose();
    id_phnoeController.dispose();
    id_nameController.dispose();
    super.dispose();
  }
}

void _showDialog(String message,BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}



