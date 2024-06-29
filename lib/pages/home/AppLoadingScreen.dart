import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppLoadingScreen extends StatefulWidget {
  const AppLoadingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppLoadingScreenState();
  }
}

class _AppLoadingScreenState extends State<AppLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 50),
        lowerBound: 0,
        upperBound: 100)
      ..repeat();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF00B14F),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 90,
              child: Image.asset(
                'images/huflitfoodlogo.png',
                fit: BoxFit.fill,
              ),
            ),
            AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  var angle = sin(animationController.value) * 0.3;
                  return Transform(
                    transform: Matrix4.rotationZ(angle),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 100,
                      height: 40,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
