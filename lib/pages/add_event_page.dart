import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_scheduler_project/pages/location_pick_page.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/resources/api/api_methods.dart';
import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:event_scheduler_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _pickedImage;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _pickedDate = DateTime.now();
  TimeOfDay _pickedTime = TimeOfDay.now();
  GeoPoint _choosenLocation = const GeoPoint(0, 0);
  bool? _isLost = true;
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Add Dog Report")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 20),
              // DropdownButton<bool>(
              //   value: _isLost,
              //   hint: Text('Is Lost?'),
              //   items: <DropdownMenuItem<bool>>[
              //     DropdownMenuItem<bool>(
              //       value: true,
              //       child: Text('Is Lost'),
              //     ),
              //     DropdownMenuItem<bool>(
              //       value: false,
              //       child: Text('Is Found'),
              //     ),
              //   ],
              //   onChanged: (bool? newValue) {
              //     setState(() {
              //       _isLost = newValue;
              //     });
              //   },
              // ),
              // SizedBox(height: 20),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Pick a date",
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectedDate();
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationPickerPage(
                        setLocation: (LatLng location) {
                          setState(() {
                            _choosenLocation =
                                GeoPoint(location.latitude, location.longitude);
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Text(_choosenLocation.latitude != 0
                    ? "Location Added"
                    : "Add Location"),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _pickImageFromGallery();
                      },
                      child: _pickedImage != null
                          ? Text("Image Added")
                          : Text("Add Image"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              TextField(
                decoration: InputDecoration(
                  labelText: _pickedTime != TimeOfDay.now()
                      ? 'Time picked'
                      : 'No time picked',
                  filled: true,
                  prefixIcon: Icon(Icons.access_time),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectTime();
                },
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  addEvent(userProvider.user.username);
                },
                child: Text("Add Dog Report"),
              ),
              SizedBox(height: 85),
            ],
          ),
        ),
      ),
    );
  }

  void addEvent(String userId) async {
    setState(() {
      isLoading = true;
    });

    print('Description: ${_descriptionController.text}');
    print('Picked Image: ${_pickedImage!}');
    print('User ID: $userId');
    print('Chosen Location: $_choosenLocation');
    print('Title: ${_titleController.text}');
    print('Picked Date: $_pickedDate');
    print('Picked Date: $_pickedTime');
    print(" is lost: $_isLost");

    try {
      // String res = await FireStoreMethods().uploadEvent(
      //   _descriptionController.text,
      //   _pickedImage!,
      //   userId,
      //   _choosenLocation,
      //   _titleController.text,
      //   _pickedDate,
      //   _pickedTime,
      // );

      String res = await ApiMethods().uploadDogReport(
          _titleController.text,
          _descriptionController.text,
          _isLost!,
          _pickedImage!,
          userId,
          _choosenLocation,
          _pickedDate,
          _pickedTime);

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _pickedDate = _picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _pickedTime,
    );
    if (picked != null && picked != _pickedTime) {
      setState(() {
        _pickedTime = picked;
      });
    }
  }

  Future _pickImageFromGallery() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _pickedImage = image;
    });
  }
}
