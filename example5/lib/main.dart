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

const defaultWidth = 100.0;

class _MyHomePageState extends State<MyHomePage> {
  bool _isZoomedIn = false;
  String _buttonTitle = "Zoom in";
  double _width = 100.0;
  final _curve = Curves.bounceOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 370,
              ),
              curve: _curve,
              width: _width,
              child: Image.asset(
                'name',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(
                () {
                  _isZoomedIn = !_isZoomedIn;
                  _buttonTitle = _isZoomedIn ? "Zoom out" : "Zoom in";
                  _width = _isZoomedIn ? 200 : defaultWidth;
                },
              );
            },
            child: Text(
              _buttonTitle,
            ),
          ),
        ],
      ),
    );
  }
}
