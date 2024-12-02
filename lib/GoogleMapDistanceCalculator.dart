import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapDistanceCalculator extends StatefulWidget {
  const GoogleMapDistanceCalculator({super.key});

  @override
  State<GoogleMapDistanceCalculator> createState() =>
      _GoogleMapDistanceCalculatorState();
}

class _GoogleMapDistanceCalculatorState
    extends State<GoogleMapDistanceCalculator> {
  GoogleMapController? googleMapController;
  Set<Marker> markers = {};
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
        centerTitle: true,
        backgroundColor: const Color(0XFF333333),
        titleTextStyle: TextStyle(color: Color(0xFFF5F5F5), fontSize: 25),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              onTap: _selectLocation,
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.872477, 35.498023),
                zoom: 12,
              ),
              markers: markers,
            ),
          ),
          Container(
            width: 400,
            color: const Color(0XFF333333),
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF00A8B5)),
              ),
              onPressed: () {
                if (selectedLocation != null) {
                  Navigator.pop(context, selectedLocation);
                } else {
                  _showErrorDialog();
                }
              },
              child: const Text("Done",
                  style: TextStyle(fontSize: 22, color: Color(0xFFF5F5F5))),
            ),
          ),
        ],
      ),
    );
  }

  void _selectLocation(LatLng tappedPoint) {
    setState(() {
      selectedLocation = tappedPoint;
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      );
    });
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0XFF333333),
          title: const Text("Error", style: TextStyle(color: Colors.white)),
          content: const Text("Please select a location on the map.",
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
