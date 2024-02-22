import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

import '../models/eventMode.dart';

class EventPage extends StatefulWidget {
  final String dogReportId;

  const EventPage({super.key, required this.dogReportId});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  LatLng _center = const LatLng(41.9961, 21.4314);
  Event? _event;

  Future<void> fetchEvent(String id) async {
    Event event = await FireStoreMethods().fetchEventById(id);

    setState(() {
      _event = event;
    });
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    fetchEvent(widget.dogReportId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Event Page")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      _event == null
                          ? 'https://images.freeimages.com/variants/VZ8KRrC1agcXw91iuorUFbjj/f4a36f6589a0e50e702740b15352bc00e4bfaf6f58bd4db850e167794d05993d?fmt=webp&h=350'
                          : _event!.photoUrl,
                    ), // replace with your image url
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    _event?.title ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 24, // replace with yrour desired font size
                      fontWeight: FontWeight
                          .bold, // replace with your desired font weight
                    ),
                  ),
                  Text(_event?.eventDate != null
                      ? DateFormat('dd.MM.yyyy').format(_event!.eventDate)
                      : "unknown"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(_event?.eventTime != null
                      ? _event!.eventTime.format(context)
                      : "unknown"),
                  SizedBox(
                    height: 20,
                  ),
                  Flex(
                    direction: Axis
                        .horizontal, // or Axis.vertical depending on your needs
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text(
                              //   "Organized By: Miroslav Krstic",
                              //   style: (TextStyle(
                              //       fontSize: 20, fontWeight: FontWeight.w600)),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                _event?.title ?? "Loading...",
                                style: (TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                              SizedBox(
                                height: 40,
                                width: 40,
                              ),
                              Container(
                                width: double.infinity,
                                height: 300,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: _center,
                                    zoom: 11.0,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId('Skopje'),
                                      position: _event?.location != null
                                          ? LatLng(_event!.location.latitude,
                                              _event!.location.longitude)
                                          : LatLng(0, 0),
                                    )
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
