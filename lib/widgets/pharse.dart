import 'package:flutter/material.dart';

Widget getErrorPharse(String comment){
  return Row(
    children: [
      const Icon(Icons.error_outline),
      const SizedBox(width: 10,),
      Text(comment)
    ],
  );
}