import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  const MyPlayer({Key? key, this.playerX}) : super(key: key);

  final playerX;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.purple,
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}