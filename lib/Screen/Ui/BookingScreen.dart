

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zainlak_tech/Services/reservations.dart';

import 'booking_details_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late String _bookingIdToDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "My Bookmarks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ).tr(),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 700,
                  child: FutureBuilder<({ List<dynamic> reservations, String? errorMessage })>(
                      future: ReservationService.getUserReservations(),
                    builder: (context, AsyncSnapshot<({ List<dynamic> reservations, String? errorMessage })> rss) {
        if (rss.connectionState == ConnectionState.waiting) {
        return const Center(
        child: CircularProgressIndicator(),
        );
        } else if (rss.connectionState ==
        ConnectionState.done) {
        if (rss.data != null) {
        return rss.data!.reservations.isEmpty
        ? Center(
        child: const Text(
        'There Are No Bookings Yet',
        style: TextStyle(
        fontSize: 24,
        ),
        ).tr(),
        )
            : RefreshIndicator(
        onRefresh: () async{
        setState((){});
        },
        child: ListView.builder(
        itemCount: rss.data!.reservations.length,
        itemBuilder: (context, index) {
        return Padding(
        padding: const EdgeInsets.only(
        left: 8.0,
        top: 12,
        ),
        child: GestureDetector(
        onTap: () {
        Navigator.of(context).push(
        MaterialPageRoute(
        builder: (context) =>
        BookingDetailsScreen(
        bookingData:
        rss.data!.reservations[index],
        ),
        ),
        );
        },
        child: Container(
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12.0),
        boxShadow: [
        BoxShadow(
        offset: const Offset(0, 3),
        blurRadius: 6,
        color: Colors.black.withOpacity(0.1),
        ),
        ],
        ),
        height: 125,
        child: Row(
        children: [
        Container(
        width: 100,
        height: double.infinity,
        decoration: BoxDecoration(
        image: DecorationImage(
        fit: BoxFit.cover,
        image: CachedNetworkImageProvider(
        rss.data!.reservations[index]['technicianId']['image'],
        ),
        ),
        borderRadius: BorderRadius.circular(12.0),
        ),
        ),
        const SizedBox(width: 10),
        Expanded(
        child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        AutoSizeText(
        "code: ${rss.data!.reservations[index]['_id']}",
        style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        ),maxLines:1
        ),
        Text(
        "${context.locale.languageCode == 'en' ? rss.data!.reservations[index]['technicianId']['category']['name'] : rss.data!.reservations[index]['technicianId']['category']['nameAr']}",
        style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        ),
        ),
        const SizedBox(height: 6),
        Text(
        "${rss.data!.reservations[index]['technicianId']['name']}",
        style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
        ),
        ),

        Text('${rss.data!.reservations[index]['date']}  ${rss.data!.reservations[index]['time']}${int.parse(rss.data!.reservations[index]['time']) <= 12 ? "AM" : "PM"}   ${rss.data!.reservations[index]['status'].toString().tr()}',style:TextStyle(
        color:rss.data!.reservations[index]['status'] == "pending" ? Colors.red : Colors.green
        ))
        ],
        ),
        ),
        ),
        GestureDetector(
        onTap: () {
        _showConfirmationDialog(
        rss.data!.reservations[index]['_id']);
        },
        child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        ),
        child: const Icon(
        Icons.delete,
        color: Colors.white,
        ),
        ),
        ),
        ],
        ),
        ),
        ),
        );
        },
        ),
        );
        }
        }

        return const Text('');
        },
        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(String bookingId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Booking').tr(),
          content: const Text('Are you sure you want to delete this booking?').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel').tr(),
            ),
            TextButton(
              onPressed: () {
                _deleteBooking(bookingId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)).tr(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBooking(String id) async {
    try {
      await ReservationService.deleteReservation(id);
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete booking')),
      );
    }
  }
}