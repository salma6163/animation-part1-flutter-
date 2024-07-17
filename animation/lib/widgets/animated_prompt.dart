import 'package:flutter/material.dart';

class AnimatedPrompt extends StatefulWidget {
  const AnimatedPrompt({
    super.key,
    required this.title,
    required this.subTitle,
    required this.child,
    required this.color,
  });

  final String title;
  final String subTitle;
  final Widget child;
  final Color color;

  @override
  State<AnimatedPrompt> createState() => _AnimatedPromptState();
}

class _AnimatedPromptState extends State<AnimatedPrompt>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _childScaleAnimation;
  late Animation<double> _containerScaleAnimation;
  late Animation<Offset> _yAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _childScaleAnimation = Tween<double>(
      begin: 7,
      end: 6,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _containerScaleAnimation = Tween<double>(
      begin: 2.0,
      end: 0.4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
      ),
    );

    _yAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.23),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller
      ..reset()
      ..forward();
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 100,
          minWidth: 100,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 160),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.subTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black54,
                        ),
                  )
                ],
              ),
              Positioned.fill(
                child: SlideTransition(
                  position: _yAnimation,
                  child: ScaleTransition(
                    scale: _containerScaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color,
                      ),
                      child: ScaleTransition(
                        scale: _childScaleAnimation,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
