import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';

class Main_Home extends StatefulWidget{

  final List<Baby> babies;
  const Main_Home(this.babies, {Key? key}) : super(key: key);

  @override
  _Main_home createState() => _Main_home();
}
class _Main_home extends State<Main_Home>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffc8c7),
        elevation: 0.0,
        iconTheme : const IconThemeData(color: Colors.black),
        title: const Text('BoB', style: TextStyle(color: Colors.black,fontSize: 15)),
      ),
      drawer: Drawer(                             //appbar 메뉴
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
                backgroundColor: Colors.white,
              ),
              accountName: Text('User name',style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold,fontSize: 20),),
              accountEmail: Text('useremail@naver.com',style: TextStyle(color: Colors.grey[800]),),
              onDetailsPressed: (){

              },
              decoration: const BoxDecoration(
                color: Color(0xffa8c1f3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)
                )
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.grey[850]),
              title: Text('Home'),
              onTap: () {
                // Navigator.push(context,
                // MaterialPageRoute(
                //     builder: (context) => Main_Cctv()));
              },
            ),
            ListTile(
              leading: Icon(Icons.camera, color: Colors.grey[850]),
              title: Text('CCTV'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt, color: Colors.grey[850]),
              title: Text('Diary'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.person_outline, color: Colors.grey[850]),
              title: Text('Mypage'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey[850]),
              title: Text('Setting'),
              onTap: () {
              },
            )
          ],
        ),
      ),

      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xffffc8c7),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40)
                  )
                ),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                          height: 150,
                          child: drawBaby(
                              widget.babies[0].name,
                              widget.babies[0].birth
                          )
                      ),
                    ],
                  ),
                ),
              ),
          )
        ],
      ),
    );
  }
}


Widget drawBaby(String name, DateTime birth){

  final now = DateTime.now();

  return Container(
      padding: const EdgeInsets.only(left: 40),
      child: Column(
          children:[
            Row(
              children: [
                Image.asset('assets/images/baby.png',scale: 5,),
                const SizedBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      birth.year.toString()+'.'+birth.month.toString()+'.'+birth.day.toString(),
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      'D+ ${DateTime(now.year, now.month, now.day).difference(birth).inDays+2}',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                )
              ],
            )

          ]
      )
  );
}
