import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper();

  @override
  Path getClip(Size size) {
    final path = Path();

    final rect = Rect.fromCircle(
      center: Offset(
        size.width / 2,
        size.height / 2,
      ),
      radius: size.width / 2,
    );

    path.addOval(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

Color getRandomColor() => Color(
      0xff000000 + math.Random().nextInt(0x00ffffff),
    );

class AnimatedColor extends StatefulWidget {
  const AnimatedColor({super.key});

  @override
  State<AnimatedColor> createState() => _AnimatedColorState();
}

class _AnimatedColorState extends State<AnimatedColor> {
  Color _color = getRandomColor();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: const CircleClipper(),
        child: TweenAnimationBuilder(
          tween: ColorTween(
            begin: getRandomColor(),
            end: _color,
          ),
          onEnd: () {
            setState(() {
              _color = getRandomColor();
            });
          },
          duration: const Duration(seconds: 5),
          builder: (context, Color? color, child) => ColorFiltered(
            colorFilter: ColorFilter.mode(
              color!,
              BlendMode.srcATop,
            ),
            child: child,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            color: getRandomColor(),
          ),
        ),
      ),
    );
  }
}
