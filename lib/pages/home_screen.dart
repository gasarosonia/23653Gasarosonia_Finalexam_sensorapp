import 'package:flutter/material.dart';
import 'package:sensorapp/screens/current_location_screen.dart';
import 'package:sensorapp/screens/geofencing.dart';
import 'package:sensorapp/screens/nearby_places_screen.dart';
import 'package:sensorapp/screens/predifined.dart';
import 'package:sensorapp/screens/simple_map_screen.dart';
import 'package:sensorapp/screens/polyline_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Location Tracking and Geofencing"),
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
                    return const SimpleMapScreen();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("Map"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const CurrentLocationScreen();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("User Live Location"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const PredefinedAreasScreen();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("Predefined Areas"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const NearByPlacesScreen();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("Near by Places"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const PolylineScreen();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("Polyline between 2 points"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const GeofencingScreen();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[500],
                textStyle: const TextStyle(fontSize: 20), // Button color
              ),
              child: const Text("Geofencing"),
            ),
          ],
        ),
      ),
    );
  }
}
