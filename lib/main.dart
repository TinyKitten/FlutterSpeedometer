import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speedometer',
      theme:
          ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'sans-serif'),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _speed = 0.0;
  double _maxSpeed = 0.0;
  StreamSubscription<Position>? _positionStream;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
  );

  @override
  void initState() {
    super.initState();
    _updateLocation();
  }

  void _updateLocation() {
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((position) {
      setState(() {
        _speed = (position.speed * 3.6).floor().toDouble();
      });
      if (_maxSpeed < _speed) {
        setState(() {
          _maxSpeed = _speed;
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    if (_positionStream != null) {
      _positionStream!.cancel();
      _positionStream = null;
    }
  }

  Widget _getGauge() {
    return SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 1500,
        axes: <RadialAxis>[
          RadialAxis(
              minimum: 0,
              maximum: 150,
              majorTickStyle: const MajorTickStyle(color: Colors.white38),
              minorTickStyle: const MinorTickStyle(color: Colors.white38),
              axisLabelStyle: const GaugeTextStyle(color: Colors.white38),
              axisLineStyle: const AxisLineStyle(
                  thickness: 0.15,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: Colors.white10),
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: _speed,
                    gradient: const SweepGradient(colors: <Color>[
                      Color(0xff3F5EFB),
                      Color(0xffFC466B),
                    ], stops: <double>[
                      0,
                      1
                    ]),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.15,
                    endWidth: 0.15)
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Text(_speed.floor().toString(),
                      style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.normal,
                          color: Colors.white)),
                  angle: 90,
                ),
                const GaugeAnnotation(
                  widget: Text('km/h',
                      style: TextStyle(fontSize: 18, color: Colors.white30)),
                  angle: 90,
                  positionFactor: 0.25,
                )
              ])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getGauge(),
            const Text("MAX SPEED",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold)),
            Container(
                margin: const EdgeInsets.only(top: 2.5),
                child: Text('${_maxSpeed.floor()} km/h',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)))
          ],
        ),
      ),
    );
  }
}
