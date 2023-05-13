import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import '../models/model.dart';

class Main_Cctv extends StatefulWidget{
  final getMyBabyFuction;
  const Main_Cctv({super.key, this.getMyBabyFuction});
  @override
  State<Main_Cctv> createState() => MainCCTVState();
}
class MainCCTVState extends State<Main_Cctv>{
  bool _isPlaying = false;
  late Baby baby;

  @override
  void initState() {
    super.initState();
    baby = widget.getMyBabyFuction();
    print(baby.name);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar_with_alarm('BoB', context),
      body: SingleChildScrollView(
        child: viewCCTV(),
      ),
    );
  }

  Widget viewCCTV() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          child: Mjpeg(
            isLive: _isPlaying,
            error: (context, error, stack) {
              print(error);
              print(stack);
              return Text(error.toString(), style: const TextStyle(color: Colors.red));
            },
            stream:
            'http://203.249.22.164:5000/video_feed', //'http://192.168.1.37:8081',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'video',
              child: TextButton(
                onPressed: () {
                },
                child: const Icon(
                    Icons.fast_rewind,
                    size:28,
                    color:Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                if(_isPlaying) {
                  setState(() {
                    _isPlaying = false;
                  });
                } else {
                  setState(() {
                    _isPlaying = true;
                  });
                }
              },
              child: Icon(
                  _isPlaying? Icons.pause : Icons.play_arrow,
                  size:28,
                  color:Colors.black),
            ),
            TextButton(
              onPressed: () {},
              child: const Icon(
                  Icons.fast_forward,
                  size:28,
                  color:Colors.black),
            ),
          ],
        ),
        Text('현재 아기 : ${baby.name}')
      ],
    );
  }
}