import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LightSensorDataScreen extends StatefulWidget {
  @override
  _LightSensorDataScreenState createState() => _LightSensorDataScreenState();
}

class _LightSensorDataScreenState extends State<LightSensorDataScreen> {
  List<double> _accelerometerValues = [0, 0, 0];
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initSensors();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initNotifications();
  }

  void _initNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _initSensors() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = [event.x, event.y, event.z];
        _adjustSmartLightBrightness();
      });
    });
  }

  void _adjustSmartLightBrightness() {
    // Adjust smart light brightness based on accelerometer values
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Light Data Visualization'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Real-time Light Data',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    show: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  minX: 0,
                  maxX: 100,
                  minY: -10,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, _accelerometerValues[0]),
                        FlSpot(20, _accelerometerValues[1]),
                        FlSpot(40, _accelerometerValues[2]),
                        FlSpot(60, _accelerometerValues[0]),
                        FlSpot(80, _accelerometerValues[1]),
                        FlSpot(100, _accelerometerValues[2]),
                      ],
                      isCurved: true,
                      colors: [
                        Colors.blue.withOpacity(0.5),
                      ],
                      barWidth: 5,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      aboveBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Accelerometer Values: (${_accelerometerValues[0].toStringAsFixed(2)}, ${_accelerometerValues[1].toStringAsFixed(2)}, ${_accelerometerValues[2].toStringAsFixed(2)})',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LightSensorDataScreen(),
  ));
}
