import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constant/AppColor.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  void SendMessageByWatsapp()async{
    if(await canLaunch('https://wa.me/${bookingData['technicianId']['phone']}')){
      await launch('https://wa.me/${bookingData['technicianId']['phone']}');
    }
  }
  void SendMail()async{
    String email = 'omarsabry8989@gmail.com';
    var url =  'mailto:${bookingData['technicianId']['email']}';
    await launch(url);
  }
  void CallPhoneNumber () async{
    var phoneUrl = 'tel://${bookingData['technicianId']['phone']}';

    await  launch(phoneUrl);
  }

  const BookingDetailsScreen({Key? key, required this.bookingData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.AppColors,
        elevation: 0,
        title: Text(
          'booking_details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ).tr(),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(bookingData['technicianId']['image']),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: IconButton(onPressed: (){
                        SendMessageByWatsapp();
                      }, icon:Icon (FontAwesomeIcons.whatsapp,color: Colors.green,)) ,
                    ),
                  ),

                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: IconButton(onPressed: (){
                        CallPhoneNumber();
                      }, icon:Icon (Icons.phone,color: Colors.blue,)) ,
                    ),
                  ),


                ],
              ),
              SizedBox(height: 16),
              Text(
                'technician_name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                '${bookingData['technicianId']['name']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'email',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                '${bookingData['technicianId']['email']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'phone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                bookingData['technicianId']['phone'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                bookingData['technicianId']['location'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                bookingData['technicianId']['category']['name'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'subcategory',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                (bookingData['technicianId']['subCategory'] as List).map((e) => e['name']).join(',\n'),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'rating',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 4),
                  Text(
                    bookingData['technicianId']['rating'].toStringAsFixed(1),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'price',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                '${bookingData['technicianId']['price']} SAR',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'booking_date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                bookingData['date'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'booking_time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                bookingData['time'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
              Text(
                bookingData['status'],
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}