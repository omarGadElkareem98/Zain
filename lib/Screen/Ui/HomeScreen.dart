
import 'dart:async';
import 'dart:convert';
import 'dart:io';



import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart' show BuildContextEasyLocalizationExtension, StringTranslateExtension, TextTranslateExtension, tr;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:zainlak_tech/Screen/Ui/SplachScreen.dart';
import 'package:zainlak_tech/Services/users.dart';

import '../../Constant/AppColor.dart';
import '../../Services/category.dart';
import '../../Services/popularTechnician.dart';
import '../../Services/technicians.dart';
import 'DetailsScreen.dart';
import 'Employee_Profile.dart';
import 'Notification_Screen.dart';
import 'ProfileScreen.dart';
import 'no_network_screen.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List> _getAllSliders() async{
    try{
      final Uri uri = Uri.parse('https://adminzaindev.zaindev.com.sa/sliders');
      http.Response response = await http.get(uri);

      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }else{
        return [];
      }
    }catch(error){
      return [];
    }
  }

  final List<String> city = [
    "  Abhā",
  "Abqaiq",
  "Al-Baḥah",
  "Al-Dammām",
  "Al-Hufūf",
  "Al-Jawf",
  "Al-Kharj (oasis)",
  "Al-Khubar",
 " Al-Qaṭīf",
  "Al-Ṭaʾif",
  "ʿArʿar",
  "Buraydah",
  "Dhahran",
  "Ḥāʾil",
  "Jiddah",
  "Jīzān",
  "Khamīs Mushayt",
  "King Khalīd Military City",
 " Mecca",
  "Medina",
  "Najrān",
  "Ras Tanura",
  "Riyadh",
 " Sakākā",
  "Tabūk",
  "Yanbuʿ",
  ];

  String ? selectedValue;


  void validateToken() async{
    bool isValidToken = await UserService.validateToken();
    if(!isValidToken){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your Session Has Ended, Login Again'),duration: Duration(seconds: 4),)
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplachScreen(token: null))
      );
    }
  }

      @override
  void initState() {
    super.initState();
    validateToken();
  }




      void NavigateToDetailsScreen (String id,String name){
        Navigator.push(context, MaterialPageRoute(builder: (context,){
          return DetailsScreen(id:id,name:name);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Container(
                width: double.infinity,

                color: Colors.white,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfileScreen())
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(8.0),
                    child: Row(

                      children: [
                        FutureBuilder(
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
                                return Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(user['image']),
                                          fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(40)
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    Text("${user['name']}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                );
                              }
                              return Text('');
                            }
                        ),
                        SizedBox(width: 8.0,),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 40,
                            child: TextField(


                              keyboardType: TextInputType.text,
                              readOnly: true,
                              onTap: () async{
                                List technicians = await TechnicianService.getAllTechnicians();

                                await showSearch(
                                  context: context,
                                  delegate: TechnicianSearchDelegate(technicians: technicians),
                                );
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.black,
                                  prefixText: 'Search'.tr(),

                                  suffixIcon: Icon(Icons.search,color: Colors.black,),
                                  hintStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),

                                  ),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),

                            ),
                          ),
                        ),
                        SizedBox(width: 8.0,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return NotificationsScreen();
                            }));
                          },
                            child: Icon(Icons.notifications_outlined,color: Colors.black,)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30)
              ),

              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(-3, 3),
                        blurRadius: 0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  child: FutureBuilder<List>(
                    future: _getAllSliders(),
                    builder: (BuildContext context,AsyncSnapshot<List> snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if(snapshot.hasError){
                        return Center(
                          child: Text('Something Went Wrong'),
                        );
                      }

                      if(snapshot.data != null){
                        if(snapshot.data!.isEmpty){
                          return Center(
                            child: Text('No Items Yet'),
                          );
                        }

                        return CarouselSlider(
                          items: snapshot.data!.map((e){
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    '${e['link']}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            reverse: true,
                            viewportFraction: 0.65,
                            aspectRatio: 2.5 / 1,
                            initialPage: 0,
                            height: 140.0,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            enableInfiniteScroll: true,
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
                ),
              )
              ,
            ),

            SizedBox(height: 12.0,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: AutoSizeText("Welcome To Zain".tr(),style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),maxLines: 1,),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text("How Can We Help You Today?",style: TextStyle(
                fontSize: 18
              ),).tr(),
            ),

            SizedBox(height: 12,),

            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

              SizedBox(width: 12,),
              Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.yellow,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'مكانك',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    items: city
                        .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 300,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.black,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.yellow,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 600,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.black,
                      ),
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
              )
                ],
              ),
            ),



            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder(
                future: CategoryService.getAllCategories(),
                builder: (context,AsyncSnapshot snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if(snapshot.hasError){
                    return Center(
                      child: Text("Something Went Wrong"),
                    );
                  }

                  if(snapshot.data != null){
                    if(snapshot.data.isEmpty){
                      return Center(
                        child: Text("No Categories Yet"),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context , index){
                          return GestureDetector(
                            onTap: (){
                              NavigateToDetailsScreen(snapshot.data[index]['_id'],snapshot.data[index]['name']);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              margin: EdgeInsets.only(top: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(snapshot.data[index]['image']),
                                  fit: BoxFit.cover
                                  ),
                                  boxShadow: [
                                  BoxShadow(
                                    offset: Offset(-3,3),
                                    blurRadius: 2,
                                    color: Colors.transparent
                                  ),
                                ]
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 30,
                                alignment: Alignment.center,

                                padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0),
                                    )
                                  ),
                                  child: Text("${context.locale.languageCode == 'en' ? snapshot.data[index]['name'] : snapshot.data[index]['nameAr']}" ,
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16),).tr()),
                            ),
                          );
                        });
                  }

                  return Text('nothing yet');
                },
              ),
            ),

            SizedBox(height: 12,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(33)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text("هل انت مزود خدمه",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23
                      ),),
                      SizedBox(height: 5,),
                      Text("سجل معنا اليوم لتطوير عملك وزياده دخلك",style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45
                      ),),
                      SizedBox(height: 5,),
                      Container(
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22)
                        ),
                        child: MaterialButton(
                          onPressed: (){} ,
                          color: Colors.white54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(child: Icon(Icons.double_arrow)),
                              SizedBox(width: 10,),
                              Text("تسجيل كمزود خدمه",style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],

        ),
      ),
    );
  }
}



class TechnicianSearchDelegate extends SearchDelegate {
  final List technicians;

  TechnicianSearchDelegate({required this.technicians});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Perform filtering based on the query
    List filteredTechnicians = technicians
        .where((technician) =>
        technician['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Build the filtered results UI
    return ListView.builder(
      itemCount: filteredTechnicians.length,
      itemBuilder: (context, index) {
        var technician = filteredTechnicians[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => employeeProfile(tech: technician),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: technician['image'],
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    technician['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Perform suggestions based on the query (optional)

    // You can implement suggestions based on the query,
    // such as fetching suggestions from an API or using a predefined list.

    // In this example, we'll return an empty container for simplicity.
    return Container();
  }
}



