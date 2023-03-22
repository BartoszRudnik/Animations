import 'dart:math';

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _sidesAnimationController;
  late AnimationController _radiusAnimationController;
  late AnimationController _rotationAnimationController;

  late Animation<int> _sidesAnimation;
  late Animation<double> _radiusAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _sidesAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );
    _radiusAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );
    _rotationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );

    _sidesAnimation = IntTween(
      begin: 3,
      end: 10,
    ).animate(
      _sidesAnimationController,
    );
    _radiusAnimation = Tween<double>(
      begin: 20.0,
      end: 400.0,
    )
        .chain(
          CurveTween(
            curve: Curves.bounceInOut,
          ),
        )
        .animate(
          _radiusAnimationController,
        );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    )
        .chain(
          CurveTween(
            curve: Curves.easeInOut,
          ),
        )
        .animate(
          _rotationAnimation,
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sidesAnimationController.repeat(
      reverse: true,
    );
    _radiusAnimationController.repeat(
      reverse: true,
    );
    _rotationAnimationController.repeat(
      reverse: true,
    );
  }

  @override
  void dispose() {
    _sidesAnimationController.dispose();
    _radiusAnimationController.dispose();
    _rotationAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(
            [
              _sidesAnimationController,
              _radiusAnimationController,
              _rotationAnimationController,
            ],
          ),
          builder: (context, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(
                _rotationAnimation.value,
              )
              ..rotateY(
                _rotationAnimation.value,
              )
              ..rotateZ(
                _rotationAnimation.value,
              ),
            child: CustomPaint(
              painter: Polygon(
                sides: _sidesAnimation.value,
              ),
              child: SizedBox(
                height: _radiusAnimation.value,
                width: _radiusAnimation.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Polygon extends CustomPainter {
  final int sides;

  Polygon({
    required this.sides,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    final path = Path();

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );
    final angle = 2 * pi / sides;

    final angles = List.generate(
      sides,
      (index) => index * angle,
    );

    final radius = size.width / 2;

    path.moveTo(
      center.dx + radius * cos(0),
      center.dy + radius * sin(0),
    );

    for (final angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }

    path.close();

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => oldDelegate is Polygon && oldDelegate.sides != sides;
}
