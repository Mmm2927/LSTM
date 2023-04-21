import 'package:flutter/material.dart';

class FeedingStopwatch extends StatefulWidget {
  const FeedingStopwatch({Key? key}) : super(key: key);

  @override
  State<FeedingStopwatch> createState() => _FeedingStopwatchState();
}

class _FeedingStopwatchState extends State<FeedingStopwatch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height-600,
      width: MediaQuery.of(context).size.width-40,
      child: Column(
        children: [
          Row(
            children: [
              Text('성장 기록',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.black
                ),
              ),
              IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.pause_circle)
              ),
              IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.circle)
              ),
              IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.cancel)
              )
            ],
          )
        ],
      ),
    );
  }
}
