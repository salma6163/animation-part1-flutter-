import 'package:animation/widgets/animated_color.dart';
import 'package:animation/widgets/animated_prompt.dart';
import 'package:animation/widgets/cube_animation.dart';
import 'package:animation/widgets/custom_animated_container.dart';
import 'package:animation/widgets/custom_drawer_animation.dart';
import 'package:animation/widgets/custom_polygon.dart';
import 'package:animation/widgets/half_circle_fliping.dart';
import 'package:animation/widgets/hero_Animation.dart';
import 'package:animation/widgets/rotating_squer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  List<Widget> animationWidgets = [
    const RotatingSquer(),
    const HalfCircleFliping(),
    const CubeAnimation(),
    const HeroAnimation(),
    const CustomAnimatedContainer(),
    const AnimatedColor(),
    const CustomPolygon(),
    const CustomDrawerAnimation(),
    const AnimatedPrompt(
      title: 'Thank You for your Perches',
      subTitle: "you delivery will arrive in two businesses days",
      color: Colors.green,
      child: Icon(Icons.check),
    )
  ];

  void showNextAnimation() {
    setState(() {
      if (index < animationWidgets.length - 1) {
        index++;
      } else {
        index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: animationWidgets[index],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNextAnimation,
        child: const Icon(Icons.next_plan),
      ),
    );
  }
}
