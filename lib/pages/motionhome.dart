import 'package:flutter/material.dart';
import 'package:sensorapp/pages/motion.dart';
import 'package:sensorapp/pages/motiondata.dart';

class SensorHomeScreen extends StatelessWidget {
  const SensorHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Motion Detection and Security"),
        centerTitle: true,
        backgroundColor: Colors.grey[500], // Dark grey app bar
      ),
      backgroundColor: Colors.grey[300], // Light grey background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MotionDetection();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("Motion Detected"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SensorDataScreen();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("Motion Data"),
            ),
          ],
        ),
      ),
    );
  }
}
