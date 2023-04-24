import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';

class FeedingStopwatch extends StatefulWidget {
  final String babyname;
  final timerClosedchange;

  FeedingStopwatch(this.babyname, {Key? key, this.timerClosedchange}) : super(key: key);

  @override
  State<FeedingStopwatch> createState() => _FeedingStopwatchState();
}

class _FeedingStopwatchState extends State<FeedingStopwatch> {


  int seconds = 0, minutes=0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  String laps = '';


  @override
  void initState(){
    // TODO: implement initState
    // start();
  }

  //Creating the stop timer function
  void stop(){
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  //Creating the reset function
  void reset(){
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps = lap;
    });
  }

  //creating the start timer function
  void start() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if(localSeconds > 59){
        if(localMinutes > 59){
          localHours++;
          localMinutes = 0;
        } else{
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 5,top: 5),
                child: Text(widget.babyname,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    (!started) ? start() : stop();
                  },
                  icon: Icon((!started) ? Icons.play_circle : Icons.pause_circle, size: 27,color: Colors.orange,),
                  padding: const EdgeInsets.only(right: 13,top: 10),
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  onPressed: () {
                    stop();
                    addLaps();
                    reset();
                    print(laps);
                    widget.timerClosedchange();
                  },
                  icon: const Icon(Icons.check_circle,size: 27,color: Colors.orange),
                  padding: const EdgeInsets.only(right: 13,top: 10),
                  constraints: const BoxConstraints(),
                ),

                IconButton(
                  onPressed: () {
                    reset();
                    widget.timerClosedchange();
                  },
                  icon: const Icon(Icons.cancel,size: 27,color: Colors.orange),
                  padding: const EdgeInsets.only(right: 15,top: 10),
                  constraints: const BoxConstraints(),
                )
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 6),
                child: Text((!started) ? '모유 수유 잠깐 쉼..' : '모유 수유중..',style: TextStyle(color: Colors.grey[800],fontSize: 16),)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(left: 6),
                child: Text('$digitHours:$digitMinutes:$digitSeconds',style: TextStyle(fontSize: 23))
            ),
          ],
        ),

      ],
    );
  }
}
