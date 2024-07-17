import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class CubeAnimation extends StatefulWidget {
  const CubeAnimation({super.key});

  @override
  State<CubeAnimation> createState() => _CubeAnimationState();
}

class _CubeAnimationState extends State<CubeAnimation>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animtion;
  @override
  void initState() {
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    _animtion = Tween<double>(begin: 0, end: pi * 2);
    super.initState();
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  final widthAndHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();

    _zController
      ..reset()
      ..repeat();

    return Center(
      child: AnimatedBuilder(
          animation: Listenable.merge(
            [
              _xController,
              _yController,
              _zController,
            ],
          ),
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(_animtion.evaluate(_xController))
                ..rotateY(_animtion.evaluate(_yController))
                ..rotateZ(_animtion.evaluate(_zController)),
              child: Stack(
                children: [
                  // back side
                  Container(
                    width: widthAndHeight,
                    height: widthAndHeight,
                    color: Colors.blue,
                  ),

                  // left side
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()..rotateY(pi / 2),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.red,
                    ),
                  ),

                  // right side
                  Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()..rotateY(-pi / 2),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.green,
                    ),
                  ),

                  //top side
                  Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()..rotateX(-pi / 2),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.purple,
                    ),
                  ),

                  //bottom side
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()..rotateX(pi / 2),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.teal,
                    ),
                  ),

                  //front side
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(
                        Vector3(
                          0,
                          0,
                          -widthAndHeight,
                        ),
                      ),
                    child: Container(
                      width: widthAndHeight,
                      height: widthAndHeight,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
