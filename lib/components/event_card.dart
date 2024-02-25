import 'dart:typed_data';

import 'package:event_scheduler_project/models/dogReportModel.dart';
import 'package:event_scheduler_project/models/eventMode.dart';
import 'package:event_scheduler_project/pages/event_page.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/resources/api/api_methods.dart';
import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:event_scheduler_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

class EventCard extends StatefulWidget {
  final DogReport dogReport;
  bool? isInMyReports;
  EventCard({
    Key? key,
    required this.dogReport,
    bool? isInMyReports,
  })  : isInMyReports = isInMyReports ?? false,
        super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  Uint8List? imageFile;

  @override
  void initState() {
    getImage();
    super.initState();
  }

  void getImage() async {
    Uint8List image = await ApiMethods().fetchImage(widget.dogReport.imgUrl);
    setState(() {
      imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventPage(
                    dogReportId: widget.dogReport.id,
                  )),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imageFile != null
                    ? MemoryImage(imageFile!)
                    : AssetImage('assets/images/dogFound.png') as ImageProvider,
              ),
            ),
            child: BottomWidgetPart(
              dogReport: widget.dogReport,
            ),
          ),
          TopWidgetPart(
            dogReport: widget.dogReport,
            isInMyReports: widget.isInMyReports,
          ),
        ],
      ),
    );
  }
}

class TopWidgetPart extends StatelessWidget {
  final DogReport dogReport;
  final bool? isInMyReports;

  const TopWidgetPart({
    super.key,
    this.isInMyReports,
    required this.dogReport,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _DatePartContainer(
            eventDate: dogReport.dateTime,
          ),
          _ButtonPartContainer(
            isInMyReports: isInMyReports,
            dogReport: dogReport,
          ),
        ],
      ),
    );
  }
}

class _ButtonPartContainer extends StatelessWidget {
  final bool? isInMyReports;
  final DogReport dogReport;

  const _ButtonPartContainer({
    super.key,
    this.isInMyReports,
    required this.dogReport,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Align(
      alignment: Alignment.topRight,
      child: isInMyReports!
          ? ElevatedButton(
              onPressed: () {},
              child: Icon(Icons.remove),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
                backgroundColor: Colors.red,
              ),
            )
          : Container(), // Empty Container (invisible) when isInMyReports is false
    );
  }

  void removeFromFavourites(String eventId, String userId, context) async {
    String res = await FireStoreMethods().removeFromFavourites(eventId, userId);

    if (res == "success") {
      showSnackBar(context, "Removed From Favourites");
    }
  }
}

class _DatePartContainer extends StatelessWidget {
  final DateTime eventDate;
  const _DatePartContainer({
    super.key,
    required this.eventDate,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
            margin: EdgeInsets.all(10),
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            width: 100,
            child: Center(
              child: Text(
                formatDate(eventDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10, // replace with your desired font size
                ),
              ),
            )),
      ),
    );
  }
}

class BottomWidgetPart extends StatelessWidget {
  final DogReport dogReport;

  const BottomWidgetPart({
    super.key,
    required this.dogReport,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.7),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        width: double.infinity,
        height: 60,
        child: Column(
          children: [
            Text(
              dogReport.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
