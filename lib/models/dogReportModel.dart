import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DogReport {
  String id;
  bool isLost;
  String userId;
  String title;
  String description;
  String imgUrl;
  DateTime dateTime; // Use DateTime for date and time
  double latitude;
  double longitude;

  // Constructor
  DogReport({
    required this.id,
    required this.isLost,
    required this.userId,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  });

  // Factory method to create DogReport from JSON
  factory DogReport.fromJson(Map<String, dynamic> json) {
    return DogReport(
      id: json['id'],
      isLost: json['lost'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      dateTime: DateFormat("yyyy-MM-ddTHH:mm:ss")
          .parse(json['dateTime']), // Adjust date format if needed
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  // Method to convert DogReport to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'isLost':
            isLost ? "true" : "false", // Convert boolean to "true" or "false
        'userId': userId,
        'title': title,
        'description': description,
        'imgUrl': imgUrl,
        'dateTime': DateFormat("yyyy-MM-ddTHH:mm:ss")
            .format(dateTime), // Adjust date format if needed
        'latitude': latitude,
        'longitude': longitude,
      };

  LatLng getLatLng() {
    return LatLng(latitude, longitude);
  }
}
