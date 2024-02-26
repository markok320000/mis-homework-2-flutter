import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:event_scheduler_project/models/chat.dart';
import 'package:event_scheduler_project/models/dogReportModel.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ApiMethods {
  String userId = "jhon";

  Future<List<DogReport>> fetchDogReports() async {
    Dio dio = Dio();
    final response = await dio.get('http://192.168.0.11:8080/api/dog-reports');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data;
      List<DogReport> dogReports =
          jsonList.map((json) => DogReport.fromJson(json)).toList();
      return dogReports;
    } else {
      throw Exception('Failed to load dog reports');
    }
  }

  Future<DogReport> getDogReportById(String id) async {
    Dio dio = Dio();
    final response =
        await dio.get('http://192.168.0.11:8080/api/dog-reports/$id');

    if (response.statusCode == 200) {
      return DogReport.fromJson(response.data);
    } else {
      throw Exception('Failed to load dog report with id $id');
    }
  }

  Future<String> uploadDogReport(
      String title,
      String description,
      bool isLost,
      Uint8List file,
      String username,
      GeoPoint location,
      DateTime eventDate,
      TimeOfDay eventTime) async {
    String dogReportid = const Uuid().v1();
    String imgUrl = await uploadImage(file);
    DateTime combinedDateTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventTime.hour,
      eventTime.minute,
    );

    DogReport dogReport = DogReport(
        id: dogReportid,
        isLost: isLost,
        userId: username,
        title: title,
        description: description,
        imgUrl: imgUrl,
        dateTime: combinedDateTime,
        latitude: location.latitude,
        longitude: location.longitude);

    Dio dio = Dio();
    try {
      print(dogReport.toJson());
      final response = await dio.post(
        'http://192.168.0.11:8080/api/dog-reports/create',
        data: dogReport.toJson(),
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        return "failure";
      }
    } catch (e) {
      return "failure";
    }
  }

  Future<String> uploadImage(Uint8List img) async {
    Dio dio = Dio();

    try {
      FormData file = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          img,
          filename: 'image.jpg',
        ),
      });

      final response = await dio.post(
        'http://192.168.0.11:8080/api/images/upload',
        data: file,
      );

      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      return "Failed to upload image";
    }
  }

  Future<Uint8List> fetchImage(String imgUrl) async {
    Dio dio = Dio();
    final response = await dio.get(
      'http://192.168.0.11:8080/api/images/$imgUrl',
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<List<DogReport>> getMyDogReports(String username) async {
    Dio dio = Dio();
    final response = await dio
        .get('http://192.168.0.11:8080/api/dog-reports/myReports/$username');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data;
      List<DogReport> dogReports =
          jsonList.map((json) => DogReport.fromJson(json)).toList();
      return dogReports;
    } else {
      throw Exception('Failed to load dog reports');
    }
  }

  Future<ChatDTO> fetchChatById(String id) async {
    Dio dio = Dio();
    final response = await dio.get('http://192.168.0.11:8080/api/chat/$id');

    if (response.statusCode == 200) {
      print(response.data);
      return ChatDTO.fromJson(response.data);
    } else {
      throw Exception('Failed to load chat');
    }
  }

  Future<ChatDTO> createChat(
      String firstParticipantId, String secondParticipantId) async {
    print("firstParticipantId: $firstParticipantId");
    print("secondParticipantId: $secondParticipantId");
    Dio dio = Dio();
    final response = await dio.get(
        "http://192.168.0.11:8080/api/chat/create/$firstParticipantId/$secondParticipantId");

    if (response.statusCode == 200) {
      ChatDTO chatDTO = ChatDTO.fromJson(response.data);
      return chatDTO;
    } else {
      throw Exception('Failed to create chat');
    }
  }

  Future<bool> deleteMyDogReport(String id) async {
    try {
      Dio dio = Dio();
      final response = await dio.delete(
        'http://192.168.0.11:8080/api/dog-reports/delete/$id',
      );

      // Check the response status code to handle success or failure
      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle other status codes as needed
        print(
            'Failed to delete dog report. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      // Handle any errors that occurred during the request
      print('Error deleting dog report: $error');
      return false;
    }
  }
}
