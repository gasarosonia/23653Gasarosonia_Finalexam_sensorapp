import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MotionDetection extends StatefulWidget {
  @override
  _MotionDetectionState createState() => _MotionDetectionState();
}

class _MotionDetectionState extends State<MotionDetection> {
  bool isMotionDetected = false;
  int motionCount = 0; // Variable to count the amount of motion detected
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  bool isDebouncing = false;
  Timer? debounceTimer;

  @override
  void initState() {
    super.initState();
    _initAccelerometer();
    _initNotifications();
  }

  void _initAccelerometer() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (!isDebouncing) {
        // Check for motion and vibrations based on accelerometer readings
        if ((event.x.abs() > 2.0 ||
                event.y.abs() > 2.0 ||
                event.z.abs() > 2.0) &&
            (event.x.abs() < 8.0 &&
                event.y.abs() < 8.0 &&
                event.z.abs() < 8.0)) {
          isDebouncing = true;
          setState(() {
            isMotionDetected = true;
          });
          _notifyUser('Unexpected movements detected!');
          motionCount++; // Increment the motion count

          // Set a debounce timer to prevent multiple counts for the same motion event
          debounceTimer = Timer(Duration(seconds: 1), () {
            isDebouncing = false;
          });
        }
      }
    });
  }

  void _notifyUser(String message) {
    // Implement your notification logic here (e.g., push notifications)
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id', // Change 'your channel id' to your actual channel id
      'your channel name', // Change 'your channel name' to your actual channel name
      // 'your channel description', // Change 'your channel description' to your actual channel description
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      0,
      'Motion Detected',
      message,
      platformChannelSpecifics,
      payload: 'Motion Detected',
    );
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

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motion Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.motion_photos_on,
              size: 100,
              color: isMotionDetected ? Colors.red : Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Motion Detected: ${isMotionDetected ? 'Yes' : 'No'}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Motion Count: $motionCount',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Reset motion detection status and count
                setState(() {
                  isMotionDetected = false;
                  motionCount = 0;
                });
              },
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MotionDetection(),
  ));
}
