import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_scheduler_project/components/chat_card.dart';
import 'package:event_scheduler_project/models/chat.dart';
import 'package:event_scheduler_project/models/dogReportModel.dart';
import 'package:event_scheduler_project/models/eventMode.dart';
import 'package:event_scheduler_project/pages/ChatPage.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/resources/api/api_methods.dart';
import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:event_scheduler_project/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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

  DogReport? selectedDogReport;

  Uint8List? foundDogIcon;
  Uint8List? lostDogIcon;

  List<DogReport> dogReports = [];
  List<LatLng> polylineCoordinates = [];

  String lostDogIconPath = "lib/assets/images/lostDog.png";
  String foundDogIconPath = "lib/assets/images/foundDog.png";

  bool lostDogsSwitched = true;

  @override
  void initState() {
    setIcons();
    getDogReports();
    getCurrentLocation();
    super.initState();
  }

  void setIcons() {
    getBytesFromAsset(lostDogIconPath, 70);
    getBytesFromAsset(foundDogIconPath, 70);
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
      if (path == lostDogIconPath) {
        lostDogIcon = img;
      } else {
        foundDogIcon = img;
      }
    });
  }

  Future<void> getDogReports() async {
    List<DogReport> fetchedReports = await ApiMethods().fetchDogReports();
    setState(() {
      this.dogReports = fetchedReports;
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
          // DropdownButton<String>(
          //   value: lostDogsSwitched ? 'Lost' : 'Found',
          //   items: <String>['Lost', 'Found']
          //       .map<DropdownMenuItem<String>>((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          //   onChanged: (value) => {
          //     setState(() {
          //       lostDogsSwitched = !lostDogsSwitched;
          //     })
          //   },
          // ),
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
                          ...dogReports.map((report) {
                            return Marker(
                              markerId: MarkerId(report.title),
                              position: report.getLatLng(),
                              icon: BitmapDescriptor.fromBytes(lostDogIcon!),
                              onTap: () {
                                setState(() {
                                  isVisibleTopPopUp = true;
                                  selectedDogReport = report;
                                });
                              },
                            );
                          })
                        },
                        zoomControlsEnabled: false,
                      ),
                    ),
                    selectedDogReport != null && isVisibleTopPopUp
                        ? GoToEventTopPopUp(
                            event: selectedDogReport!,
                            onButtonPressed: () async {
                              await getPolyPoints(
                                PointLatLng(currentLocation.latitude,
                                    currentLocation.longitude),
                                PointLatLng(selectedDogReport!.latitude,
                                    selectedDogReport!.longitude),
                              );
                            },
                          )
                        : SizedBox()
                  ],
                )),
    );
  }
}

class GoToEventTopPopUp extends StatefulWidget {
  final DogReport event;
  final Future<void> Function() onButtonPressed;

  const GoToEventTopPopUp({
    super.key,
    required this.event,
    required this.onButtonPressed,
  });

  @override
  State<GoToEventTopPopUp> createState() => _GoToEventTopPopUpState();
}

class _GoToEventTopPopUpState extends State<GoToEventTopPopUp> {
  Uint8List? imageFile;
  late UserProvider _userProvider;
  @override
  void initState() {
    getImage();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  void getImage() async {
    Uint8List image = await ApiMethods().fetchImage(widget.event.imgUrl);
    setState(() {
      imageFile = image;
    });
  }

  void openChat() async {
    ChatDTO openChat = await ApiMethods()
        .createChat(_userProvider.user.username, widget.event.userId);

    if (!_userProvider.user.chats.contains(openChat.id)) {
      _userProvider.user.chats.add(openChat.id);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          chat: openChat,
          // Pass any other required parameters to ChatCard
        ),
      ),
    );
  }

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
                  Container(
                    width:
                        80, // Adjust the size of the Container by changing the width and height
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageFile != null
                            ? MemoryImage(imageFile!)
                            : AssetImage('assets/images/dogFound.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Text(
                      widget.event.title,
                      style: TextStyle(
                        fontSize:
                            20, // Change this value to adjust the font size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onButtonPressed();
                  },
                  child: Text('Go to location'),
                  style: TextButton.styleFrom(
                    iconColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    openChat();
                  },
                  child: Text('Contact'),
                  style: TextButton.styleFrom(
                    iconColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
