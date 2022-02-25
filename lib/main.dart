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
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  @override
  void initState() {
    super.initState();
    _updateLocation();
  }

  void _updateLocation() {
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        _speed = position.speed * 3.6;
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
              axisLineStyle: AxisLineStyle(
                  thickness: 0.15,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: Colors.grey),
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: _speed,
                    gradient: const SweepGradient(
                        colors: <Color>[Color(0xFFBC4E9C), Color(0xFFF80759)],
                        stops: <double>[0.25, 0.75]),
                    startWidth: 25,
                    endWidth: 25)
              ],
              pointers: <GaugePointer>[
                NeedlePointer(value: _speed)
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Container(
                        child: Text('${_speed}km/h',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                    angle: 90,
                    positionFactor: 0.5)
              ])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_getGauge()],
        ),
      ),
    );
  }
}
