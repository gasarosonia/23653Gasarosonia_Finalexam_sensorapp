import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensorapp/pages/charts.dart';
//import 'package:sensorapp/pages/ball_game_page.dart';
// import 'package:sensorapp/pages/compass.dart';
//import 'package:sensorapp/pages/dashboard.dart';
import 'package:sensorapp/pages/home_screen.dart';
//import 'package:sensorapp/pages/light.dart';
import 'package:sensorapp/pages/lighthome.dart';
//import 'package:sensorapp/pages/motion.dart';
import 'package:sensorapp/pages/motionhome.dart';
import 'package:sensorapp/util/smart_device_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // list of smart devices
  List mySmartDevices = [
    // [ smartDeviceName, iconPath ]
    ["Lights", "lib/icons/light-bulb.png"],
    ["Motion Detection", "lib/icons/mose.png"],
    ["Live Location", "lib/icons/gps.png"],
    ["Data Chart", "lib/icons/analytics.png"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // app bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // menu icon
                    Image.asset(
                      'lib/icons/menu.png',
                      height: 45,
                      color: Colors.grey[800],
                    ),
                    // account icon
                    Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.grey[800],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // welcome home
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Smart Home Monitoring System,",
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade800),
                    ),
                    Text(
                      'Sonia GASARO',
                      style: GoogleFonts.bebasNeue(fontSize: 72),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),

              const SizedBox(height: 25),

              // smart devices grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  "Sensors",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // grid
              GridView.builder(
                itemCount: mySmartDevices.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  void navigateToPage() {
                    if (mySmartDevices[index][0] == "Motion Detection") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SensorHomeScreen()),
                      );
                    } else if (mySmartDevices[index][0] == "Data Chart") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SensorDataPage()),
                      );
                    } else if (mySmartDevices[index][0] == "Live Location") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else if (mySmartDevices[index][0] == "Lights") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LightHomeScreen()),
                      );
                    }
                  }

                  return SmartDeviceBox(
                    smartDeviceName: mySmartDevices[index][0],
                    iconPath: mySmartDevices[index][1],
                    onPressed: navigateToPage,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
