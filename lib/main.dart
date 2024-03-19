import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'dart:math' as math;


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Stacked Cards'),
          ),
          body: StackApp()),
    );
  }
}

class StackApp extends StatefulWidget {
  const StackApp({super.key});

  @override
  State<StackApp> createState() => _StackAppState();
}

class _StackAppState extends State<StackApp> with TickerProviderStateMixin {
  bool isRotationEnabled = true;
  bool isScrollIndicatorShown = false;
  final SwiperController _swiperController = SwiperController();
  int _currentIndex = 0;


  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();


    _swiperController.addListener(() {
      print("Dragging");
      setState(() {
        _currentIndex = _swiperController.index!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }


  final List<double> rotationAngles = [0, 5, 10, 15];

  Matrix4 _cardRotation1(int index) {
    int positionDifference = (index - _currentIndex + colors.length) % colors.length;


    if (positionDifference > 0 && positionDifference <= 3) {
      double rotationDegrees = 5.0 * positionDifference;
      double radians = rotationDegrees * (math.pi / 180);
      return Matrix4.identity()..rotateZ(radians);
    }


    return Matrix4.identity();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            child: Stack(
              children: <Widget>[
                Swiper(
                  allowImplicitScrolling: true,
                  itemBuilder: (BuildContext context, int index) {

                    return Transform(
                      alignment: Alignment.center,
                      transform: _cardRotation1(index),
                      child: Container(
                        width: 300,
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: colors[index],
                        ),
                        child: Center(
                          child: Text("Card $index",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    );
                  },
                  itemCount: colors.length,
                  controller: _swiperController,
                  itemWidth: 300.0,
                  itemHeight: 400.0,
                  axisDirection: AxisDirection.right,
                  layout: SwiperLayout.STACK,
                  onIndexChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Rotation Enabled'),
                    value: isRotationEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        isRotationEnabled = value;
                      });
                    },
                    secondary: const Icon(Icons.rotate_right),
                  ),
                  SwitchListTile(
                    title: const Text('Shows Scroll Indicator'),
                    value: isScrollIndicatorShown,
                    onChanged: (bool value) {
                      setState(() {
                        isScrollIndicatorShown = value;
                      });
                    },
                    secondary: const Icon(Icons.indeterminate_check_box),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
