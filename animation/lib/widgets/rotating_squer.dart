import 'dart:math' show pi;

import 'package:flutter/material.dart';

class RotatingSquer extends StatefulWidget {
  const RotatingSquer({super.key});

  @override
  State<RotatingSquer> createState() => _RotatingSquerState();
}

class _RotatingSquerState extends State<RotatingSquer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    super.initState();

    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..rotateY(_animation.value),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 15),
                    color: Colors.grey,
                    blurRadius: 15,
                    spreadRadius: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
