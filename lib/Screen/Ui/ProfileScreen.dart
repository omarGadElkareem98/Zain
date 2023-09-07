
  import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:zainlak_tech/Screen/Ui/HomeScreen.dart';
import 'package:zainlak_tech/Screen/Ui/MainScreen.dart';
import 'package:zainlak_tech/Screen/Ui/SplachScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zainlak_tech/Services/users.dart';

class ProfileScreen extends StatefulWidget {
    const ProfileScreen({Key? key}) : super(key: key);

    @override
    State<ProfileScreen> createState() => _ProfileScreenState();
  }

  class _ProfileScreenState extends State<ProfileScreen> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        appBar: AppBar(
          elevation: 0,
          title: TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return MainScreen();
            }));
          }, child: Text('Back'.tr(),style: TextStyle(color: Colors.indigo,fontSize: 22,fontStyle: FontStyle.italic),),),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: IconButton(onPressed: (){}, icon: Icon(Icons.edit))
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: FutureBuilder(
                future: UserService.getUser(),
                builder: (context,AsyncSnapshot snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if(snapshot.hasError){
                    return Center(
                      child: Icon(Icons.error_outline,size: 30,color: Colors.black,),
                    );
                  }

                  if(snapshot.data != null){
                    Map user = snapshot.data;

                    return Stack(

                        children: [
                          Card(

                            margin: EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 30,),
                                  Align( alignment: Alignment.center, child: Text(user['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                                  SizedBox(height: 10,),
                                  Align( alignment: Alignment.center, child: Text('Joined Since',style: TextStyle(fontSize: 17,color: Colors.indigo),).tr(args: [dateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(user['createdAt']))).toString()])),
                                  SizedBox(height: 20,),
                                  Divider(thickness: 1,),
                                  SizedBox(height: 40,),
                                  Text('Contact Info',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),).tr(),
                                  SizedBox(height: 20,),
                                  Text("Email",style: TextStyle(color: Colors.black,fontSize: 18),).tr(args: [user['email']]),
                                  SizedBox(height: 15,),
                                   Text('location',style: TextStyle(color: Colors.black,fontSize: 18),).tr(args: [user['location']]),

                                  SizedBox(height: 10,),
                                  Text('phoneNumber',style: TextStyle(color: Colors.black,fontSize: 18),).tr(args: [user['phone']]),

                                  SizedBox(height: 30,),

                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 20,right: 20,left: 20,top: 0),
                                      child: MaterialButton(
                                        onPressed: () async{
                                          SharedPreferences shared = await SharedPreferences.getInstance();
                                          await shared.remove('token');
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (context) => SplachScreen(token: null))
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Logout',style: TextStyle(color: Colors.white,fontSize: 18),).tr(),
                                            SizedBox(width: 10,),
                                            Icon(Icons.logout_rounded,color: Colors.white,)
                                          ],
                                        ),
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Container(
                                width:70 ,
                                height:70 ,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(width: 5,color: Theme.of(context).scaffoldBackgroundColor),
                                    image: DecorationImage(image:CachedNetworkImageProvider(user['image']),fit: BoxFit.fill)
                                ),
                              )
                            ],)
                        ]
                    );
                  }

                  return Text('');
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  void SendMessageByWatsapp()async{

    String PhoneNumber = '+201156467293';

    await  launch('https://wa.me/$PhoneNumber?text=hello');

  }
  void SendMail()async{
    String email = 'omarsabry8989@gmail.com';
    var url =  'mailto:$email';
    await launch(url);
  }
  void CallPhoneNumber () async{
    String PhoneNumber = '+01156467293';
    var phoneUrl = 'tel://$PhoneNumber';

    await  launch(phoneUrl);
  }


