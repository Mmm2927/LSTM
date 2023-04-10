import 'package:flutter/material.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class Main_Cctv extends StatefulWidget{
  @override
  _Main_Cctv createState() => _Main_Cctv();
}
class _Main_Cctv extends State<Main_Cctv>{
  final String _streamUrl = 'https://media.w3.org/2010/05/sintel/trailer.mp4';
  late VlcPlayerController _vlcViewController;
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    _vlcViewController = VlcPlayerController.network('http://203.249.22.164:8081/', hwAcc: HwAcc.FULL, autoPlay: false, options: VlcPlayerOptions());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar_with_alarm('BoB', context),
      body: Column(
        children: [
          _streamUrl == null
          ? Container()
          : VlcPlayer(
              controller: _vlcViewController,
              aspectRatio: 16/9,
              placeholder: const Center(child: CircularProgressIndicator()
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                },
                child: const Icon(
                    Icons.fast_rewind,
                    size:28,
                    color:Colors.black),
              ),
              TextButton(
                onPressed: () {
                  if(_isPlaying) {
                    setState(() {
                      _isPlaying = false;
                    });
                    _vlcViewController.pause();
                  } else {
                    setState(() {
                      _isPlaying = true;
                    });
                    _vlcViewController.play();
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
          )
        ],
      ),
    );
  }
}