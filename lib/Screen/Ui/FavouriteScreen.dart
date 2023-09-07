import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zainlak_tech/Screen/Ui/Employee_Profile.dart';
import 'package:zainlak_tech/Services/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {


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
                  child: Text(
                    "Favourite",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ).tr(),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 700,
                  child: FutureBuilder<
                      ({List<dynamic> techs, String? errorMessage})>(
                    future: UserService.getAllFavoriteTechnicians(),
                    builder: (context,
                        AsyncSnapshot<
                                ({List<dynamic> techs, String? errorMessage})>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data != null) {
                        if (snapshot.data!.errorMessage != null) {
                          return Center(
                            child: Text(
                              snapshot.data!.errorMessage.toString(),
                              style: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold
        ),
                            ),
                          );
                        }

                        return snapshot.data!.techs.isEmpty
                            ? Center(
                                child: Text(
                                  'No Favourites Yet',
                                  style: TextStyle(fontSize: 24),
                                ).tr(),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data!.techs.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => employeeProfile(
                                              tech:
                                                  snapshot.data!.techs[index]),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot.data!
                                                    .techs[index]['image'],
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${snapshot.data!.techs[index]['name']}",
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "${context.locale.languageCode == 'en' ? snapshot.data!.techs[index]['category']['name'] : snapshot.data!.techs[index]['category']['nameAr']}",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.orange,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          "4.5",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          "(50 Reviews)",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ).tr(),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                      }

                      return Text('');
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
}
