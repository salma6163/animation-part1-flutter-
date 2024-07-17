import 'package:flutter/material.dart';

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;

  const Person({
    required this.name,
    required this.age,
    required this.emoji,
  });
}

const people = [
  Person(
    name: 'Mareai',
    age: 25,
    emoji: "👨🏻‍💻",
  ),
  Person(
    name: 'Ali',
    age: 20,
    emoji: "👨‍💻",
  ),
  Person(
    name: 'Ahmed',
    age: 22,
    emoji: "‍💻",
  ),
];

class HeroAnimation extends StatelessWidget {
  const HeroAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Click on one to see details"),
          const SizedBox(height: 16),
          SizedBox(
            width: 400,
            height: 200,
            child: GridView.builder(
              itemCount: people.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final person = people[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailPage(person: person),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.blueGrey,
                    width: 100,
                    height: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: person.name,
                          child: Text(
                            person.emoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                        Text(
                          person.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${person.age} years old",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.person,
  });
  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          flightShuttleBuilder: (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                      scale: animation.drive(
                        Tween<double>(
                          begin: 0,
                          end: 1,
                        ).chain(
                          CurveTween(
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ),
                      child: toHeroContext.widget),
                );
              case HeroFlightDirection.pop:
                return Material(
                  color: Colors.transparent,
                  child: fromHeroContext.widget,
                );
            }
          },
          tag: person.name,
          child: Text(
            person.emoji,
            style: const TextStyle(
              fontSize: 40,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              person.name,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${person.age} years old",
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
