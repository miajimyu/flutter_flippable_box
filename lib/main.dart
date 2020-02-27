import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => setState(() => isFlipped = !isFlipped),
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeOut,
            tween: Tween<double>(begin: 0, end: isFlipped ? 180 : 0),
            builder: (context, value, child) {
              var content = value >= 90
                  ? _buildCard('back', 350, 350)
                  : _buildCard('front', 250, 200);
              return RotationY(
                rotationY: value,
                child: RotationY(
                  rotationY: value >= 90 ? 180 : 0,
                  child: Card(
                    color: Colors.blue,
                    child: AnimatedBackground(child: content),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String label, double width, double height) {
    return Container(
      width: width,
      height: height,
      child: Center(child: Text(label, style: TextStyle(color: Colors.white))),
    );
  }
}

class RotationY extends StatelessWidget {
  //Degrees to rads constant
  static const double degrees2Radians = pi / 180;

  final Widget child;
  final double rotationY;

  const RotationY({Key key, @required this.child, this.rotationY = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) //These are magic numbers, just use them :)
          ..rotateY(rotationY * degrees2Radians),
        child: child);
  }
}

class AnimatedBackground extends StatelessWidget {
  final Container child;
  const AnimatedBackground({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: child.constraints.maxWidth,
        height: child.constraints.maxHeight,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: child);
  }
}
