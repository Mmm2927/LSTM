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
      backgroundColor: Color(0xF9F9F9FF),
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
          ),
          Positioned(
            top: 130,
              child: Container(
                height: 90,
                width: MediaQuery.of(context).size.width-40,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xfffdb1a5),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 3
                    )
                  ]
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('버튼을 길게 누르면 타이머가 작동합니다.',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700]
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 20,top: 10),
                      child: Row(
                        children: [
                          SizedBox.fromSize(
                            size: Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.red,
                                child: InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.dining_outlined,), // <-- Icon
                                      Text("수유",style: TextStyle(fontSize: 15),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox.fromSize(
                            size: Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.orange,
                                child: InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.baby_changing_station,), // <-- Icon
                                      Text("배변",style: TextStyle(fontSize: 15),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox.fromSize(
                            size: Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.yellow,
                                child: InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.baby_changing_station,), // <-- Icon
                                      Text("소변",style: TextStyle(fontSize: 15),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),SizedBox(
                            width: 20,
                          ),
                          SizedBox.fromSize(
                            size: Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.green,
                                child: InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.bedroom_child_outlined,), // <-- Icon
                                      Text("수면",style: TextStyle(fontSize: 15),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),SizedBox(
                            width: 20,
                          ),
                          SizedBox.fromSize(
                            size: Size(50, 50),
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue,
                                child: InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.add_circle,), // <-- Icon
                                      Text("직접 입력",style: TextStyle(fontSize: 13),), // <-- Text
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
          ),
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
