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
              majorTickStyle: const MajorTickStyle(color: Colors.white),
              minorTickStyle: const MinorTickStyle(color: Colors.white),
              axisLabelStyle: const GaugeTextStyle(color: Colors.white),
              axisLineStyle: const AxisLineStyle(
                  thickness: 0.15,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: Colors.white),
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: _speed,
                    gradient: const SweepGradient(
                        colors: <Color>[Color(0xFFBC4E9C), Color(0xFFF80759)],
                        stops: <double>[0.25, 0.75]),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.15,
                    endWidth: 0.15)
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                    needleColor: Colors.white,
                    value: _speed,
                    knobStyle: const KnobStyle(color: Colors.white))
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text('${_speed.floor()}km/h',
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    angle: 90,
                    positionFactor: 0.5)
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
          children: <Widget>[_getGauge()],
        ),
      ),
    );
  }
}
