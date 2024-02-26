import 'dart:typed_data';

import 'package:event_scheduler_project/models/chat.dart';
import 'package:event_scheduler_project/models/dogReportModel.dart';
import 'package:event_scheduler_project/pages/ChatPage.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/resources/api/api_methods.dart';
import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart';

import '../models/eventMode.dart';

class EventPage extends StatefulWidget {
  final String dogReportId;

  const EventPage({super.key, required this.dogReportId});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  LatLng? _center;
  DogReport? _dogReport;
  Uint8List? imageFile;
  late UserProvider _userProvider;
  Future<void> fetchEvent(String id) async {
    DogReport dogReport =
        await ApiMethods().getDogReportById(widget.dogReportId);

    setState(() {
      _dogReport = dogReport;
      getImage();
    });
  }

  void getImage() async {
    Uint8List image = await ApiMethods().fetchImage(_dogReport!.imgUrl);
    setState(() {
      imageFile = image;
    });
  }

  void openChat() async {
    ChatDTO openChat = await ApiMethods()
        .createChat(_userProvider.user.username, _dogReport!.userId);

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
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    super.initState();
  }

  void isLoading() {
    if (_dogReport == null || imageFile == null) {
      CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("")),
        body: _dogReport == null || imageFile == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                          fit: BoxFit.cover,
                          image: imageFile != null
                              ? MemoryImage(imageFile!)
                              : AssetImage('assets/images/dogFound.png')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          _dogReport?.title ?? 'Loading...',
                          style: TextStyle(
                            fontSize:
                                24, // replace with yrour desired font size
                            fontWeight: FontWeight
                                .bold, // replace with your desired font weight
                          ),
                        ),
                        Text(_dogReport?.dateTime != null
                            ? DateFormat('dd.MM.yyyy')
                                .format(_dogReport!.dateTime)
                            : "unknown"),
                        SizedBox(
                          height: 20,
                        ),
                        Text(_dogReport?.dateTime != null
                            ? _dogReport!.dateTime.hour.toString() +
                                ":" +
                                _dogReport!.dateTime.minute.toString()
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
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      _dogReport?.title ?? "Loading...",
                                      style: (TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 300,
                                      child: _dogReport?.latitude == null
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : GoogleMap(
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: LatLng(
                                                    _dogReport!.latitude,
                                                    _dogReport!.longitude),
                                                zoom: 11.0,
                                              ),
                                              markers: {
                                                Marker(
                                                  markerId: MarkerId('Skopje'),
                                                  position: LatLng(
                                                      _dogReport!.latitude,
                                                      _dogReport!.longitude),
                                                ),
                                              },
                                            ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                    ),
                                    _userProvider.user.username !=
                                            _dogReport!.userId
                                        ? TextButton(
                                            onPressed: () {
                                              openChat();
                                            },
                                            child: Text('Contact'),
                                            style: TextButton.styleFrom(
                                              iconColor: Colors.white,
                                              backgroundColor: Colors.blue,
                                            ),
                                          )
                                        : Container(),
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
