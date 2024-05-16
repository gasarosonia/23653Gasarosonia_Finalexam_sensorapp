import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MaterialApp(
    home: SensorDataPage(),
  ));
}

class SensorDataPage extends StatefulWidget {
  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  List<double> _motionData = [];
  List<double> _lightData = [];
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  late StreamSubscription<UserAccelerometerEvent> _lightSensorSubscription;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initSensors();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    _lightSensorSubscription.cancel();
    super.dispose();
  }

  void _initSensors() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x.isFinite) {
        setState(() {
          _motionData.add(event.x);
          if (_motionData.length > 20) {
            _motionData.removeAt(0);
          }
        });
      }
    });

    _lightSensorSubscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      double lightLevel = event.x;
      if (lightLevel.isFinite) {
        _checkLightLevels(lightLevel);
      }
    });
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _checkLightLevels(double lightLevel) {
    setState(() {
      _lightData.add(lightLevel);

      if (_lightData.length > 20) {
        _lightData.removeAt(0);
      }

      if (lightLevel < 0.5) {
        _notifyUser('Low Ambient Light Detected');
      } else if (lightLevel > 0.7) {
        _notifyUser('High Ambient Light Detected');
      }
    });
  }

  void _notifyUser(String message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '4',
      'graph',
      channelDescription: 'Graph notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      0,
      'Ambient Light',
      message,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Data'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Motion Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300,
                padding: EdgeInsets.all(20),
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles:
                          SideTitles(showTitles: true, reservedSize: 30),
                      bottomTitles:
                          SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    borderData: FlBorderData(
                        show: true, border: Border.all(color: Colors.grey)),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _motionData
                            .asMap()
                            .entries
                            .where((entry) => entry.value.isFinite)
                            .map((entry) =>
                                FlSpot(entry.key.toDouble(), entry.value))
                            .toList(),
                        isCurved: true,
                        colors: [Colors.blue],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'Light Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 300,
                padding: EdgeInsets.all(20),
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles:
                          SideTitles(showTitles: true, reservedSize: 30),
                      bottomTitles:
                          SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    borderData: FlBorderData(
                        show: true, border: Border.all(color: Colors.grey)),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _lightData
                            .asMap()
                            .entries
                            .where((entry) => entry.value.isFinite)
                            .map((entry) =>
                                FlSpot(entry.key.toDouble(), entry.value))
                            .toList(),
                        isCurved: true,
                        colors: [Colors.yellow],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
