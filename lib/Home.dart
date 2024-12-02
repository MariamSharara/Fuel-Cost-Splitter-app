import 'package:flutter/material.dart';
import 'package:fuelapp/GoogleMapDistanceCalculator.dart';
import 'package:fuelapp/TextFormField.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color darkGray = const Color(0XFF333333);
  Color lightGray = const Color(0xFFF5F5F5);
  Color primarycolor = const Color(0xFF00A8B5);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstlocationController =
      TextEditingController();
  final TextEditingController _secondlocationController =
      TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _fuelEfficiencyController =
      TextEditingController();
  final TextEditingController _fuelPriceController = TextEditingController();
  final TextEditingController _passengersNbController = TextEditingController();

  String _fuelCost = '';
  String _costPerPerson = '';
  double _distanceInKm = 0.0;

  void _openMapAndSelectLocation(TextEditingController controller) async {
    LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const GoogleMapDistanceCalculator()),
    );
    if (selectedLocation != null) {
      controller.text =
          'Latitude: ${selectedLocation.latitude}, Longitude: ${selectedLocation.longitude}';
      _calculateDistance();
    }
  }

  void _calculateDistance() {
    if (_firstlocationController.text.isNotEmpty &&
        _secondlocationController.text.isNotEmpty) {
      String firstLocationText = _firstlocationController.text;
      String secondLocationText = _secondlocationController.text;
      double lat1 =
          double.parse(firstLocationText.split(',')[0].split(':')[1].trim());
      double lng1 =
          double.parse(firstLocationText.split(',')[1].split(':')[1].trim());
      double lat2 =
          double.parse(secondLocationText.split(',')[0].split(':')[1].trim());
      double lng2 =
          double.parse(secondLocationText.split(',')[1].split(':')[1].trim());
      double distanceInMeters =
          Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
      setState(() {
        _distanceInKm = distanceInMeters / 1000;
        _distanceController.text = _distanceInKm.toStringAsFixed(2);
      });
    }
  }

  void calculateCost() {
    if (_formKey.currentState?.validate() ?? false) {
      double distance = double.tryParse(_distanceController.text) ?? 0;
      double fuelEfficiency =
          double.tryParse(_fuelEfficiencyController.text) ?? 0;
      final fuelPrice = double.tryParse(_fuelPriceController.text) ?? 0;
      final passengersNb = int.tryParse(_passengersNbController.text) ?? 1;
      final totalFuel = distance / fuelEfficiency;
      final totalCost = totalFuel * fuelPrice;
      final perPersonCost = totalCost / passengersNb;

      setState(() {
        _fuelCost = totalCost.toStringAsFixed(2);
        _costPerPerson = perPersonCost.toStringAsFixed(2);
        showResults();
      });
    }
  }

  void showResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: darkGray,
          title: const Text("The fuel cost",
              style: TextStyle(color: Colors.white)),
          content: Text(
            "Dear user, to go to your destination\nIt'll cost you:\nCost Detail: ${_fuelCost}\nPer Person: ${_costPerPerson}",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fuel Cost Splitter "),
        centerTitle: true,
        backgroundColor: darkGray,
        titleTextStyle: TextStyle(color: lightGray, fontSize: 25),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Fuel cost calculator',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: _firstlocationController,
                          hintText: 'Tap to enter your first Location',
                          labelText: 'First location',
                          icon: Icons.location_on_sharp,
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          onTap: () => _openMapAndSelectLocation(
                              _firstlocationController),
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _secondlocationController,
                          hintText: 'Tap to enter your second Location',
                          labelText: 'Second location',
                          icon: Icons.location_on_sharp,
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          onTap: () => _openMapAndSelectLocation(
                              _secondlocationController),
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _distanceController,
                          hintText: 'Enter the distance',
                          labelText: 'Distance',
                          icon: Icons.directions_car_sharp,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _fuelEfficiencyController,
                          hintText: 'Enter fuel efficiency',
                          labelText: 'Fuel Efficiency',
                          icon: Icons.local_gas_station_sharp,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _fuelPriceController,
                          hintText: 'Enter fuel price',
                          labelText: 'Fuel Price',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _passengersNbController,
                          hintText: 'Enter number of passengers',
                          labelText: 'Number of Passengers',
                          icon: Icons.people_alt_outlined,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: calculateCost,
                                child: const Text(
                                  "Calculate",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primarycolor),
                                  foregroundColor:
                                      MaterialStateProperty.all(lightGray),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ))
              ]))),
      backgroundColor: lightGray,
    );
  }
}
