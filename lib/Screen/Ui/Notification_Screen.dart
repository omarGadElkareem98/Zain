import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zainlak_tech/Services/users.dart';
import '../../Provider/UserProvider.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('notifications').tr()),
          backgroundColor: Colors.black,
        ),
        // drawer: Drawer(
        //   child: DrawerScreen(),
        // ),
        body: FutureBuilder<({List notifications, String? errorMessage})>(
            future: UserService.getUserNotifications(),
        builder: (BuildContext context,
        AsyncSnapshot<({List notifications, String? errorMessage})>
            snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColor.AppColors,
          ),
        );
      }
      if (snapshot.data != null) {
        List notifications = snapshot.data!.notifications;

        if (notifications.isEmpty) {
          return Center(child: Text("Notifications is empty now").tr());
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {

            });
          },
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(notifications[index]['_id'].toString()),
                background: Container(
                  color: Colors.red,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                ),
                onDismissed: (direction) async{
                  bool isNotificationDeleted = await UserService.deleteUserNotification(id: notifications[index]['_id']);
                  if(isNotificationDeleted){
                    setState(() {

                    });
                  }
                },
                child: ListTile(
                  title: Text('${notifications[index]['title']}'),
                  subtitle: Text('${notifications[index]['body']}'),
                  trailing: Text('${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(notifications[index]['createdAt']))}'),
                ),
              );
            },
          ),
        );
      }
      return Text("");
    },
    ),
    );
  }
}
