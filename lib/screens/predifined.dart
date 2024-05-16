import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PredefinedAreasScreen extends StatefulWidget {
  const PredefinedAreasScreen({Key? key}) : super(key: key);

  @override
  _PredefinedAreasScreenState createState() => _PredefinedAreasScreenState();
}

class _PredefinedAreasScreenState extends State<PredefinedAreasScreen> {
  late GoogleMapController googleMapController;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(-1.959949384811476, 30.092605216405385),
    zoom: 14,
  );

  Set<Marker> markers = {};
  Map<String, LatLng> predefinedAreas = {
    'Home': LatLng(-1.959949384811476, 30.092605216405385),
    'School': LatLng(-1.9545677873293255, 30.104118589068968),
  };

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Predefined Areas"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            Position position = await _determinePosition();

            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14,
                ),
              ),
            );

            markers.clear();

            markers.add(
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(position.latitude, position.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
              ),
            );

            _checkPredefinedAreas(position);
          } catch (e) {
            print('Error getting current position: $e');
          } finally {
            setState(() {});
          }
        },
        label: const Text("Check Predefined Areas"),
        icon: const Icon(Icons.location_searching),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw 'Location permission denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    return Geolocator.getCurrentPosition();
  }

  void _checkPredefinedAreas(Position position) {
    for (String areaName in predefinedAreas.keys) {
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        predefinedAreas[areaName]!.latitude,
        predefinedAreas[areaName]!.longitude,
      );

      bool isInsideArea = distanceInMeters <= 100;

      if (isInsideArea &&
          !markers.any((marker) => marker.markerId.value == areaName)) {
        markers.add(
          Marker(
            markerId: MarkerId(areaName),
            position: predefinedAreas[areaName]!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        );
        _notifyUser('Entered $areaName area');
      } else if (!isInsideArea &&
          markers.any((marker) => marker.markerId.value == areaName)) {
        markers.removeWhere((marker) => marker.markerId.value == areaName);
        _notifyUser('Exited $areaName area');
      }
    }
  }

  void _notifyUser(String message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      0,
      'Predefined Area',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
