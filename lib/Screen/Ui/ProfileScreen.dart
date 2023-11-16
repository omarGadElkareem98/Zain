import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zainlak_tech/Screen/Ui/MainScreen.dart';
import 'package:zainlak_tech/Screen/Ui/SplachScreen.dart';
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
        title: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MainScreen();
            }));
          },
          child: Text(
            'Back'.tr(),
            style: const TextStyle(
                color: Colors.indigo,
                fontSize: 22,
                fontStyle: FontStyle.italic),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: FutureBuilder(
              future: UserService.getUser(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      size: 30,
                      color: Colors.black,
                    ),
                  );
                }

                if (snapshot.data != null) {
                  Map user = snapshot.data;

                  return Stack(children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 20),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  user['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: const Text(
                                  'Joined Since',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.indigo),
                                ).tr(args: [
                                  dateFormat
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(user['createdAt'])))
                                      .toString()
                                ])),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const Text(
                              'Contact Info',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ).tr(),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Email",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ).tr(args: [user['email']]),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'location',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ).tr(args: [user['location']]),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'phoneNumber',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ).tr(args: [user['phone']]),
                            const SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, right: 20, left: 20, top: 0),
                                child: MaterialButton(
                                  onPressed: () async {
                                    SharedPreferences shared =
                                        await SharedPreferences.getInstance();
                                    await shared.remove('token');
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SplachScreen(
                                                    token: null)));
                                  },
                                  color: Colors.black,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Logout',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ).tr(),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.logout_rounded,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
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
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  width: 5,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              image: DecorationImage(
                                  image:
                                      CachedNetworkImageProvider(user['image']),
                                  fit: BoxFit.fill)),
                        )
                      ],
                    )
                  ]);
                }

                return const Text('');
              },
            ),
          ),
        ),
      ),
    );
  }
}

void SendMessageByWatsapp() async {
  String PhoneNumber = '+201156467293';

  await launch('https://wa.me/$PhoneNumber?text=hello');
}

void SendMail() async {
  String email = 'omarsabry8989@gmail.com';
  var url = 'mailto:$email';
  await launch(url);
}

void CallPhoneNumber() async {
  String PhoneNumber = '+01156467293';
  var phoneUrl = 'tel://$PhoneNumber';

  await launch(phoneUrl);
}
