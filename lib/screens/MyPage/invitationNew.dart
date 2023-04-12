import 'package:flutter/material.dart';
import 'package:get/get.dart' as GET;
import 'package:bob/widgets/appbar.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/models/model.dart';
class InvitationNew extends StatefulWidget{
  final List<Baby> babies;
  const InvitationNew(this.babies, {super.key});
  @override
  State<InvitationNew> createState() => _InvitationNew();
}
class _InvitationNew extends State<InvitationNew> {
  int _valueGender = 0;
  TextEditingController idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('초대', true),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('초대할 ID'),
            Padding(
              padding : EdgeInsets.fromLTRB(0, 10, 0, 30),
              child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: idController,
              decoration: formDecoration('아이디를 입력해주세요'),
                onChanged: (val){
                  setState(() {});
                },
              ),
            ),
            const Text('아기 선택'),
            Padding(
              padding : EdgeInsets.fromLTRB(0, 10, 0, 30),
              child: Text('아기 선택'),

            ),
            const Text('관계'),
            Padding(
              padding : EdgeInsets.fromLTRB(0, 10, 0, 100),
              child: Wrap(
                  spacing: 10.0,
                  children: List<Widget>.generate(
                      3, (int index){
                    List<String> gender = ['부모', '가족','베이비시터'];
                    return ChoiceChip(
                        elevation: 6.0,
                        padding: const EdgeInsets.all(10),
                        selectedColor: const Color(0xffff846d),
                        label: Text(gender[index]),
                        selected: _valueGender == index,
                        onSelected: (bool selected){
                          setState((){
                            _valueGender = (selected ? index : null)!;
                          });
                        }
                    );
                  }).toList()
              ),
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    padding: const EdgeInsets.all(20),
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xfffa625f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    )
                ),
                onPressed: (){},
                child: Text('등록'))
          ],
        ),
      )
    );
  }

}