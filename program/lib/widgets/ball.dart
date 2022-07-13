import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  const MyBall({Key? key, required this.ballX, required this.ballY}) : super(key: key);

  final double ballX;
  final double ballY;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX, ballY),
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.brown
        ),
      ),
    ); 
  }
}