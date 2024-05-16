import 'package:flutter/material.dart';
import 'package:sensorapp/pages/light.dart';
import 'package:sensorapp/pages/lightdata.dart';

class LightHomeScreen extends StatelessWidget {
  const LightHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Light Level Sensing and Automation"),
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
                    return Lights();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("Device's Ambient Light"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LightSensorDataScreen();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("Light Data"),
            ),
          ],
        ),
      ),
    );
  }
}
