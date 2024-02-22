import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerPage extends StatefulWidget {
  final Function setLocation;

  const LocationPickerPage({super.key, required this.setLocation});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng _center = const LatLng(-33.86, 151.20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick a Location"),
      ),
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _center = position.target;
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.pin_drop,
              size: 50,
              color: Colors.red,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  widget.setLocation(_center);
                  print(_center);
                  Navigator.pop(context);
                },
                child: Text('Add Event Location'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
