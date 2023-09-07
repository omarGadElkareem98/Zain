import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:zainlak_tech/Screen/Ui/About.dart';
import 'package:zainlak_tech/Screen/Ui/Languages.dart';
import 'package:zainlak_tech/Screen/Ui/Terms.dart';
import 'package:zainlak_tech/Screen/Ui/products_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SplachScreen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Text(
              'More Services',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColor.AppColors,
              ),
            ).tr(),
            SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  buildMenuItem(
                    iconData: Icons.privacy_tip,
                    text: 'Conditions & Terms'.tr(),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Terms();
                      }));
                    },
                  ),
                  buildMenuItem(
                    iconData: Icons.language,
                    text: 'Change Language'.tr(),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Languages();
                      }));
                    },
                  ),
                  buildMenuItem(
                    iconData: Icons.info,
                    text: 'About Zainlak'.tr(),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return About();
                      }));
                    },
                  ),
                  buildMenuItem(
                    iconData: Icons.shopping_bag,
                    text: 'Products'.tr(),
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProductsScreen()),
                      );
                    },
                  ),
                  buildMenuItem(
                    iconData: Icons.logout,
                    text: 'Logout'.tr(),
                    onTap: () async {
                      SharedPreferences shared = await SharedPreferences.getInstance();
                      await shared.remove('token');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SplachScreen(token: null)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({required IconData iconData, required String text, required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          iconData,
          size: 32,
          color: AppColor.AppColors,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.AppColors,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: AppColor.AppColors,
        ),
        onTap: onTap,
      ),
    );
  }
}
