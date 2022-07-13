import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, this.icon, this.function}) : super(key: key);

  final icon;
  final function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.white,
          width: 50,
          height: 50,
          child: Center(child: Icon(icon)),
        )
      ),
    );
  }
}