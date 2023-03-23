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

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      drawer: Material(
        child: Container(
          color: const Color(0xff24283b),
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: 100,
              top: 100,
            ),
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Drawer'),
        ),
        body: Container(
          color: const Color(0xff414868),
        ),
      ),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
    required this.child,
    required this.drawer,
  });

  final Widget drawer;
  final Widget child;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late AnimationController _xChildController;
  late Animation<double> _yRotationAnimation;

  late AnimationController _xDrawerController;
  late Animation<double> _yRotationAnimationDrawer;

  @override
  void initState() {
    super.initState();

    _xChildController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _yRotationAnimation = Tween<double>(
      begin: 0,
      end: -pi / 2,
    ).animate(
      _xChildController,
    );

    _xDrawerController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _yRotationAnimationDrawer = Tween<double>(
      begin: pi / 2,
      end: 0,
    ).animate(
      _xChildController,
    );
  }

  @override
  void dispose() {
    _xChildController.dispose();
    _xDrawerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.8;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _xChildController.value += details.delta.dx / maxDrag;
        _xDrawerController.value += details.delta.dx / maxDrag;
      },
      onHorizontalDragEnd: (details) {
        if (_xChildController.value < 0.5) {
          _xChildController.reverse();
          _xDrawerController.reverse();
        } else {
          _xChildController.forward();
          _xDrawerController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(
          [
            _xChildController,
            _xDrawerController,
          ],
        ),
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                color: Colors.grey,
              ),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(
                    3,
                    2,
                    0.001,
                  )
                  ..translate(
                    _xChildController.value * maxDrag,
                  )
                  ..rotateY(
                    _yRotationAnimation.value,
                  ),
                child: widget.child,
              ),
              Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(
                    3,
                    2,
                    0.001,
                  )
                  ..translate(
                    -screenWidth + _xDrawerController.value * maxDrag,
                  )
                  ..rotateY(
                    _yRotationAnimationDrawer.value,
                  ),
                child: widget.drawer,
              ),
            ],
          );
        },
      ),
    );
  }
}
