import 'dart:math' show pi;

import 'package:flutter/material.dart';

class HalfCircleFliping extends StatefulWidget {
  const HalfCircleFliping({super.key});

  @override
  State<HalfCircleFliping> createState() => _HalfCircleFlipingState();
}

class _HalfCircleFlipingState extends State<HalfCircleFliping>
    with TickerProviderStateMixin {
  late AnimationController _rotationAnimationController;
  late Animation<double> _rotationAnimation;

  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  final animationDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();

    _rotationAnimationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
        parent: _rotationAnimationController,
        curve: Curves.bounceOut,
      ),
    );

    // flip animation
    _flipAnimationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _flipAnimationController,
        curve: Curves.bounceOut,
      ),
    );

    // status

    _rotationAnimationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _flipAnimation = Tween<double>(
            begin: _flipAnimation.value,
            end: _flipAnimation.value + pi,
          ).animate(
            CurvedAnimation(
              parent: _flipAnimationController,
              curve: Curves.bounceOut,
            ),
          );

          // reset the flip animation

          _flipAnimationController
            ..reset()
            ..forward();
        }
      },
    );

    _flipAnimationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _rotationAnimation = Tween<double>(
            begin: _rotationAnimation.value,
            end: _rotationAnimation.value + -(pi / 2),
          ).animate(
            CurvedAnimation(
              parent: _rotationAnimationController,
              curve: Curves.bounceOut,
            ),
          );

          _rotationAnimationController
            ..reset()
            ..forward();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _flipAnimationController.dispose();
    _rotationAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        _rotationAnimationController
          ..reset()
          ..forward();
      },
    );
    return Center(
      child: AnimatedBuilder(
          animation: _rotationAnimationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(
                  _rotationAnimation.value,
                ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                      animation: _flipAnimationController,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()
                            ..rotateY(
                              _flipAnimation.value,
                            ),
                          child: ClipPath(
                            clipper: HalfCircleClipper(
                              side: CircleSide.left,
                            ),
                            child: Container(
                              width: 200,
                              height: 200,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }),
                  AnimatedBuilder(
                      animation: _flipAnimationController,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..rotateY(_flipAnimation.value),
                          child: ClipPath(
                            clipper: HalfCircleClipper(
                              side: CircleSide.right,
                            ),
                            child: Container(
                              width: 200,
                              height: 200,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            );
          }),
    );
  }
}

enum CircleSide {
  left,
  right,
}

extension TOPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool clockWise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockWise = false;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockWise = true;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockWise,
    );

    path.close();

    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  HalfCircleClipper({
    super.reclip,
    required this.side,
  });

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
