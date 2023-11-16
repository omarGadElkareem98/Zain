import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zainlak_tech/Screen/Ui/BookingScreen.dart';
import 'package:zainlak_tech/Screen/Ui/FavouriteScreen.dart';
import 'package:zainlak_tech/Screen/Ui/HomeScreen.dart';
import 'package:zainlak_tech/Screen/Ui/MoreScreen.dart';
import 'package:zainlak_tech/Screen/Ui/ProfileScreen.dart';

import 'no_network_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  final navigatorKey = GlobalKey<NavigatorState>();



  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    connectivitySubscription.cancel();
  }


  void toast(String? value,
      {ToastGravity? gravity,
        length = Toast.LENGTH_SHORT,
        Color? bgColor,
        Color? textColor,
        bool print = false}) {
    if (value!.isEmpty || (!kIsWeb && Platform.isLinux)) {
    } else {
      Fluttertoast.showToast(
        msg: value,
        gravity: gravity,
        toastLength: length,
        backgroundColor: bgColor,
        textColor: textColor,
        timeInSecForIosWeb: 2,
      );
    }
  }
  bool isCurrentlyOnNoInternet = false;

  void init() async {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        isCurrentlyOnNoInternet = true;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NoInternetScreen())
        );

        print("dissss");
      } else {
        if (isCurrentlyOnNoInternet) {
          Navigator.pop(context);
          isCurrentlyOnNoInternet = false;
          print("no int");
          toast('Internet is connected.');
        }
      }
    });
  }

  int pageIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const BookingScreen(),
    const FavouriteScreen(),
    const ProfileScreen(),
    const MoreScreen(),
  ];

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Press back again to exit').tr(),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              label: 'Home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 1 ? Icons.book : Icons.book_outlined,
              ),
              label: 'Bookings'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 2 ? Icons.favorite : Icons.favorite_outline,
              ),
              label: 'Favorites'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 3 ? Icons.person : Icons.person_outline,
              ),
              label: 'Profile'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                pageIndex == 4 ? Icons.more_horiz : Icons.more_horiz_outlined,
              ),
              label: 'More'.tr(),
            ),
          ],
          backgroundColor: Colors.red,
          elevation: 50,
          currentIndex: pageIndex,
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.black,
          showUnselectedLabels: true,
        ),
        body: screens[pageIndex],
      ),
    );
  }
}