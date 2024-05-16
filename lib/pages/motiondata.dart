import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  List<double> _xData = [];
  List<double> _yData = [];
  List<double> _zData = [];
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initAccelerometer();
    _initNotifications();
  }

  void _initAccelerometer() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _xData.add(event.x);
        _yData.add(event.y);
        _zData.add(event.z);

        // Limit the number of data points to display
        if (_xData.length > 50) {
          _xData.removeAt(0);
          _yData.removeAt(0);
          _zData.removeAt(0);
        }

        // Check if the x value exceeds a threshold
        if (event.x > 2.0) {
          _sendNotification('Accelerometer Alert',
              'X value exceeds threshold: ${event.x.toStringAsFixed(2)}');
        }
      });
    });
  }

  void _initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '5', // Change this to a unique channel ID
      'Notification Channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
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
        title: Text('Motion Data Visualization'),
        backgroundColor: const Color.fromARGB(255, 166, 196, 210),
      ),
      body: Container(
        color: const Color.fromARGB(255, 167, 190, 201),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Motion Data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: _xData.length.toDouble(),
                    minY: _yData
                        .reduce((min, value) => value < min ? value : min),
                    maxY: _yData
                        .reduce((max, value) => value > max ? value : max),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _yData
                            .asMap()
                            .map((index, value) => MapEntry(index.toDouble(),
                                FlSpot(index.toDouble(), value)))
                            .values
                            .toList(),
                        isCurved: false,
                        colors: [Colors.blueAccent],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
