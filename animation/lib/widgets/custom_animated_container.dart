import 'package:flutter/material.dart';

class CustomAnimatedContainer extends StatefulWidget {
  const CustomAnimatedContainer({super.key});

  @override
  State<CustomAnimatedContainer> createState() =>
      _CustomAnimatedContainerState();
}

const defaultWidth = 200.0;

class _CustomAnimatedContainerState extends State<CustomAnimatedContainer> {
  double _width = defaultWidth;
  String buttonText = 'Zoom In';
  bool isZoomed = false;
  var _curve = Curves.bounceIn;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 370),
          curve: _curve,
          width: _width,
          child: Image.asset('assets/images/desktop.png'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isZoomed = !isZoomed;
              _width =
                  isZoomed ? MediaQuery.of(context).size.width : defaultWidth;
              buttonText = isZoomed ? 'Zoom Out' : 'Zoom In';
              _curve = isZoomed ? Curves.easeInQuint : Curves.bounceIn;
            });
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
