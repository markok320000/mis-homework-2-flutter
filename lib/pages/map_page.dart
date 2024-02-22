import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_scheduler_project/models/eventMode.dart';
import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:event_scheduler_project/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng currentLocation = LatLng(0, 0);

  bool isVisibleTopPopUp = false;

  Event? selectedEvent;

  Uint8List? currentLocationIcon;

  List<Event> events = [];
  List<LatLng> polylineCoordinates = [];

  bool lostDogsSwitched = true;

  @override
  void initState() {
    getBytesFromAsset("lib/assets/images/foundDog.png", 70);
    getEvents();
    getCurrentLocation();
    super.initState();
  }

  void getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    Uint8List img = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
    setState(() {
      currentLocationIcon = img;
    });
  }

  Future<void> getEvents() async {
    List<Event> fetchedEvents = await FireStoreMethods().getEvents();
    print(fetchedEvents);
    setState(() {
      this.events = fetchedEvents;
    });
  }

  Future<void> getPolyPoints(
      PointLatLng currentLocation, PointLatLng destination) async {
    polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyALcwDRDkzn7qkBiosTeMH3kcnDa4Mb-jQ',
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {});
    }
  }

  Future<void> getCurrentLocation() async {
    Position point = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(point.latitude, point.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MapPage"),
        actions: <Widget>[
          DropdownButton<String>(
            value: lostDogsSwitched ? 'Lost' : 'Found',
            items: <String>['Lost', 'Found']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => {
              setState(() {
                lostDogsSwitched = !lostDogsSwitched;
              })
            },
          ),
        ],
      ),
      body: Container(
          child: currentLocation.latitude == 0
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 60,
                    height: 60,
                    child:
                        CircularProgressIndicator(), // Show a loading spinner while waiting.,
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: currentLocation,
                          zoom: 14.0,
                        ),
                        polylines: {
                          Polyline(
                              polylineId: PolylineId("route"),
                              points: polylineCoordinates),
                        },
                        markers: {
                          Marker(
                            markerId: MarkerId("Source"),
                            position: currentLocation,
                          ),
                          ...events.map((event) {
                            return Marker(
                                markerId: MarkerId(event.title),
                                position: event.geoLocationToLatLng(),
                                icon: BitmapDescriptor.fromBytes(
                                    currentLocationIcon!),
                                onTap: () {
                                  setState(() {
                                    isVisibleTopPopUp = true;
                                    selectedEvent = event;
                                  });
                                });
                          })
                        },
                        zoomControlsEnabled: false,
                      ),
                    ),
                    selectedEvent != null && isVisibleTopPopUp
                        ? GoToEventTopPopUp(
                            event: selectedEvent!,
                            onButtonPressed: () async {
                              await getPolyPoints(
                                PointLatLng(currentLocation.latitude,
                                    currentLocation.longitude),
                                PointLatLng(selectedEvent!.location.latitude,
                                    selectedEvent!.location.longitude),
                              );
                            },
                          )
                        : SizedBox()
                  ],
                )),
    );
  }
}

class GoToEventTopPopUp extends StatelessWidget {
  final Event event;
  final Future<void> Function() onButtonPressed;

  const GoToEventTopPopUp({
    super.key,
    required this.event,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        event.photoUrl), // Replace with your image URL
                    radius:
                        40, // Adjust the size of the CircleAvatar by changing the radius
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Text(
                      event.title,
                      style: TextStyle(
                        fontSize:
                            20, // Change this value to adjust the font size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                onButtonPressed();
              },
              child: Text('Go To Event'),
              style: TextButton.styleFrom(
                iconColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
