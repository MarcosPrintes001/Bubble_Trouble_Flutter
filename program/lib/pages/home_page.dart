// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/widgets/ball.dart';
import 'package:tetris/widgets/button.dart';
import 'package:tetris/widgets/missile.dart';
import 'package:tetris/widgets/player.dart';
import 'dart:async';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// ignore: camel_case_types
enum direction {LEFT, RIGHT}

class _HomePageState extends State<HomePage> {

  //player Variables
  static double playerX = 0;

  //missel variables
  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

  //ball variables
  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = direction.LEFT;

  void startGame(){
    double time = 0;
    double height = 0;
    double velocity = 70; //how strong jump is

    Timer.periodic(const Duration(milliseconds: 5), (timer){
    //quadratic equation that models a bounce(upside down parabola)
    height = -5 * time * time + velocity * time;

    //if the ball reaches the ground, reset the jump
    if(height < 0){
      time = 0;
    }

    //update the new ball position
    setState(() {
      ballY = heightToPosition(height);
    });

      //if the ball hits the left wall, then change direction to right
      if(ballX-0.005 < -1){
        ballDirection = direction.RIGHT;
      }
      //if the ball hits the right wall, then change direction to left
      else if (ballX+0.005 > 1){
        ballDirection = direction.LEFT;
      }

      //move ball in the correct direction
      if(ballDirection == direction.LEFT){
        setState(() {
          ballX -=0.005;
        });
      } else if(ballDirection == direction.RIGHT){
        setState(() {
          ballX +=0.005;
        });
      }

    //check if ball hits the player
    if(playerDies()){
      timer.cancel();
      _showDialog();
    }
    
    //keep the time going
    time += 0.1;

    });
  }

  void _showDialog(){
    showDialog(context: context, 
    builder: (BuildContext context){
      return const AlertDialog(
        backgroundColor: Colors.grey,
        title: Text("Game Over",
          style: TextStyle(
            color: Colors.red
          ),
        ),
      );
    });
  }

  void moveLeft(){
    setState(() {
      if(playerX - 0.1 < -1){
        //do nothing
      }else{
        playerX -= 0.1;
      }
      
      //only make the X coordinate the same when it isn't in the middle of a shot
      if(!midShot){
        missileX = playerX;
      }

    });
  }
  
  void moveRight(){
    setState(() {
      if(playerX + 0.1 > 1){
        //do nothing
      }else{
        playerX += 0.1;
      }
      //only make the X coordinate the same when it isn't in the middle of a shot
      if(!midShot){
        missileX = playerX;
      }    
    });
  }

  void fireMissile(){
    if(midShot == false){
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        //shots fired
        midShot = true;

        //missile grows til it hits the top of the screen
        setState(() {
          missileHeight +=10;
        });

        //stop missile when it hits the top of the screen
        if(missileHeight > MediaQuery.of(context).size.height * 3/4){
          resetMissele();
          timer.cancel();
        }

        //check if missile has hit the ball
        if(ballY > heightToPosition(missileHeight) && (ballX - missileX).abs() < 0.03){
          resetMissele();
          ballX = 5;
          timer.cancel();
        }
      });
    }
  }

  //convert height to a position
  double heightToPosition(double height){
    double totalHeight = MediaQuery.of(context).size.height * 3/4;
    double position = 1-2 * height/ totalHeight;
    return position;
  }

  void resetMissele() {
    missileX = playerX;
    missileHeight = 10;
    midShot = false;
  }

  bool playerDies(){
    //if the ball position and the player position 
    //are the same, then player dies
    if((ballX - playerX).abs() < 0.1 &&  ballY > 0.95){
      return true;
    }else{
      return false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event){
        if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft) || event.isKeyPressed(LogicalKeyboardKey.keyA)){
          moveLeft();
        } else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight) || event.isKeyPressed(LogicalKeyboardKey.keyD)){
          moveRight();
        }
        if(event.isKeyPressed(LogicalKeyboardKey.space)){
          fireMissile();
        }
      },

      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[300],
              child: Center(
                child: Stack(
                  children: [

                    MyBall(
                      ballX: ballX, 
                      ballY: ballY
                    ),
                    MyMissile(
                      height: missileHeight,
                      missileX: missileX,
                    ),
                    MyPlayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
    
          Expanded(
            child: Container(
              color: Colors.grey[500],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.play_arrow,
                    function: startGame,
                  ),
                  MyButton(
                    icon: Icons.arrow_back,
                    function: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    function: fireMissile,
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    function: moveRight,
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  } 
}
