import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AnimatedPrompt(
          title: 'title',
          subtitle: 'subtitle',
          child: Icon(
            Icons.check,
          ),
        ),
      ),
    );
  }
}

class AnimatedPrompt extends StatefulWidget {
  const AnimatedPrompt({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
  }) : super(
          key: key,
        );

  final String title;
  final String subtitle;
  final Widget child;

  @override
  State<AnimatedPrompt> createState() => _AnimatedPromptState();
}

class _AnimatedPromptState extends State<AnimatedPrompt> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> iconScaleAnimation;
  late Animation<double> containerScaleAnimation;
  late Animation<Offset> yAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );

    yAnimation = Tween<Offset>(
      begin: const Offset(
        0,
        0,
      ),
      end: const Offset(
        0,
        -0.23,
      ),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    iconScaleAnimation = Tween<double>(
      begin: 7,
      end: 6,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    containerScaleAnimation = Tween<double>(
      begin: 2.0,
      end: 0.4,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController
      ..reset()
      ..forward();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 100,
          minWidth: 100,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 160,
                  ),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: SlideTransition(
                position: yAnimation,
                child: ScaleTransition(
                  scale: containerScaleAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: ScaleTransition(
                        scale: iconScaleAnimation,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
