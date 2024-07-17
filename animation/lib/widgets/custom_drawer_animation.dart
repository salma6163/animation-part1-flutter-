import 'dart:math' show pi;

import 'package:flutter/material.dart';

class CustomDrawerAnimation extends StatelessWidget {
  const CustomDrawerAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DrawerPage(
                drawer: Material(
                  child: Container(
                    color: const Color(0x0902A6F1),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 100,
                        top: 100,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          'Item $index',
                        ),
                      ),
                    ),
                  ),
                ),
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Drawer'),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: const Color(0x0902A6F1),
                          child: const Text('Swipe right to open the drawer'),
                        ),
                        const Icon(Icons.swipe_right)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: const Text('Go to drawer page'),
      ),
    );
  }
}

class DrawerPage extends StatefulWidget {
  const DrawerPage({
    super.key,
    required this.child,
    required this.drawer,
  });
  final Widget child;
  final Widget drawer;
  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with TickerProviderStateMixin {
  late AnimationController _xControllerForChild;
  late Animation<double> _yAnimationForChild;

  late AnimationController _xControllerForDrawer;
  late Animation<double> _yAnimationForDrawer;

  @override
  void initState() {
    super.initState();
    _xControllerForChild = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _yAnimationForChild = Tween<double>(
      begin: 0.0,
      end: -pi / 2,
    ).animate(_xControllerForChild);

    _xControllerForDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _yAnimationForDrawer = Tween<double>(
      begin: pi / 2.7,
      end: 0.0,
    ).animate(_xControllerForDrawer);
  }

  @override
  void dispose() {
    _xControllerForDrawer.dispose();
    _xControllerForChild.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.8;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final delta = details.delta.dx / maxDrag;
        _xControllerForChild.value += delta;
        _xControllerForDrawer.value += delta;
      },
      onHorizontalDragEnd: (details) {
        if (_xControllerForChild.value < 0.5) {
          _xControllerForChild.reverse();
          _xControllerForDrawer.reverse();
        } else {
          _xControllerForChild.forward();
          _xControllerForDrawer.forward();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(
          [
            _xControllerForChild,
            _xControllerForDrawer,
          ],
        ),
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                color: Colors.black12,
              ),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(_xControllerForChild.value * maxDrag)
                  ..rotateY(_yAnimationForChild.value),
                child: widget.child,
              ),
              Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(
                    -screenWidth + _xControllerForDrawer.value * maxDrag,
                  )
                  ..rotateY(_yAnimationForDrawer.value),
                child: widget.drawer,
              ),
            ],
          );
        },
      ),
    );
  }
}
