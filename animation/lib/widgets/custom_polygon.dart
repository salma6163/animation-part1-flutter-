import 'dart:math' show pi, cos, sin;

import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final int sides;

  MyPainter({
    super.repaint,
    required this.sides,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const startAngel = -33;

    final paint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 3;

    final path = Path();

    final center = Offset(size.width / 2, size.height / 2);

    final angle = (2 * pi) / sides;

    final polyAngels = List.generate(
      sides,
      (index) => index * angle + startAngel,
    );

    final radius = size.width / 2;

    path.moveTo(
      center.dx + radius * cos(startAngel),
      center.dy + radius * sin(startAngel),
    );

    for (final angle in polyAngels) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is MyPainter && oldDelegate.sides != sides;
}

class CustomPolygon extends StatefulWidget {
  const CustomPolygon({super.key});

  @override
  State<CustomPolygon> createState() => _CustomPolygonState();
}

class _CustomPolygonState extends State<CustomPolygon>
    with TickerProviderStateMixin {
  late AnimationController _sidesController;
  late Animation<int> _animation;

  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _sidesController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 4,
      ),
    );

    _animation = IntTween(
      begin: 3,
      end: 10,
    ).animate(
      _sidesController,
    );

    _radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _radiusAnimation = Tween(begin: 20.0, end: 400.0)
        .chain(
          CurveTween(
            curve: Curves.bounceInOut,
          ),
        )
        .animate(
          _radiusController,
        );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _rotationAnimation = Tween(
      begin: 0.0,
      end: 2 * pi,
    )
        .chain(
          CurveTween(
            curve: Curves.easeInOut,
          ),
        )
        .animate(
          _rotationController,
        );
  }

  @override
  void didChangeDependencies() {
    _sidesController.repeat(reverse: true);
    _radiusController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _sidesController.dispose();
    _radiusController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: AnimatedBuilder(
          animation: Listenable.merge(
            [
              _sidesController,
              _radiusController,
            ],
          ),
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(_rotationAnimation.value)
                ..rotateY(_rotationAnimation.value)
                ..rotateZ(_rotationAnimation.value),
              child: CustomPaint(
                painter: MyPainter(sides: _animation.value),
                child: SizedBox(
                  width: _radiusAnimation.value,
                  height: _radiusAnimation.value,
                ),
              ),
            );
          }),
    );
  }
}
