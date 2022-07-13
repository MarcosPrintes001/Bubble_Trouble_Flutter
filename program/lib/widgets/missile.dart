import 'package:flutter/material.dart';

class MyMissile extends StatelessWidget {
  const MyMissile({Key? key, this.missileX, this.height}) : super(key: key);

  final missileX;
  final height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missileX, 1),
      child: Container(
        width: 2,
        height: height,
        color: Colors.grey,
      ),
    );               
    
  }
}