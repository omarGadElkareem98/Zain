
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:zainlak_tech/Screen/Ui/Employee_Profile.dart';
import 'package:zainlak_tech/Screen/Ui/sub_categories_technicians.dart';
import 'package:zainlak_tech/Services/subCategories.dart';
import 'package:zainlak_tech/Services/technicians.dart';

import 'ProfileScreen.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  final String name;

  const DetailsScreen({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.AppColors,
        title: Text(widget.name,style: TextStyle(
          fontSize: 24,
          color: Colors.white
        ),),
        elevation: 0,
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
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: FutureBuilder(
          future: SubCategoriesService.getAllSubCategories(
              parentCategory: widget.id),
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: AppColor.AppColors,
                ),
              );
            }

            if (snapshot.data != null) {
              if (snapshot.data.isEmpty) {
                return Center(
                  child: Text(
                    'No subCategories Yet',
                    style: TextStyle(
                      color: AppColor.AppColors,
                      fontSize: 24,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh:() async{
                  setState(() {

                  });
              },
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SubCategoriesTechnicians(
                              subCategoryId: snapshot.data[index]['_id'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${context.locale.languageCode == 'en' ? snapshot.data[index]['name'] : snapshot.data[index]['nameAr']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "${snapshot.data[index]['price']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: AppColor.AppColors,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return Text('');
          },
        ),
      ),
    );
  }
}
