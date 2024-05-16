import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Lights extends StatefulWidget {
  @override
  _LightsState createState() => _LightsState();
}

class _LightsState extends State<Lights> {
  double? brightness;
  bool isLightOn = false;
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

  void _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '2',
      'lights',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Smart Light Notification',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _initSensors() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        brightness = (event.y + 10) / 20;
        _adjustSmartLightBrightness();
      });
    });
  }

  void _adjustSmartLightBrightness() {
    if (brightness != null) {
      if (brightness! < 0.5 && !isLightOn) {
        _notifyUser('Low Ambient Light');
        _showNotification('Low Ambient Light');
      } else if (brightness! > 0.7) {
        _notifyUser('High Ambient Light');
        _showNotification('High Ambient Light');
      }

      if (brightness! < 1 && !isLightOn) {
        // Do nothing, wait for manual toggle
      } else if (brightness! >= 0.1 && !isLightOn) {
        isLightOn = true;
        _turnOnSmartLight();
        _notifyUser('Smart Light turned on');
        _showNotification('Smart Light turned on');
      } else if (brightness! < 0.1 && isLightOn) {
        isLightOn = false;
        _turnOffSmartLight();
        _notifyUser('Smart Light turned off');
        _showNotification('Smart Light turned off');
      }
    }
  }

  void _turnOnSmartLight() {
    print('Smart Light is turned on');
  }

  void _turnOffSmartLight() {
    print('Smart Light is turned off');
  }

  void _notifyUser(String message) {
    print('Notification: $message');
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
        title: Text('Ambient Light Sensor Simulation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isLightOn ? Colors.yellow : Colors.grey,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(30),
              child: Icon(
                Icons.lightbulb,
                size: 150,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Brightness: ${brightness?.toStringAsFixed(2) ?? 'Unknown'}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Switch(
              value: isLightOn,
              onChanged: (value) {
                setState(() {
                  isLightOn = value;
                  if (isLightOn) {
                    _turnOnSmartLight();
                    _notifyUser('Smart Light turned on');
                    _showNotification('Smart Light turned on');
                  } else {
                    _turnOffSmartLight();
                    _notifyUser('Smart Light turned off');
                    _showNotification('Smart Light turned off');
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Lights(),
  ));
}
