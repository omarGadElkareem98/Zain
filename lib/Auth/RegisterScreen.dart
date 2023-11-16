import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:zainlak_tech/Auth/LoginScreen.dart';
import 'package:zainlak_tech/Services/users.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _location = TextEditingController();
  String locationData = '';

  bool _imageUploaded = false;
  File? _image;

  final TextEditingController _phoneController = TextEditingController();

  @override
  void NavigateToLoginScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isCreatingAccountLoading = false;
  String loadingMessage = "";

  Future<void> validateSignup() async {
    try {
      setState(() {
        isCreatingAccountLoading = true;
      });

      Map<String, dynamic> data = await UserService.register(
        name: _nameController.text,
        password: _password.text,
        location: locationData,
        phone: '+966${_phoneController.text}',
        email: _emailController.text,
      );

      await UserService.uploadUserImage(
        userId: data['user']['_id'],
        imagePath: _image!.path,
      );
      setState(() {
        isCreatingAccountLoading = false;
      });
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        isCreatingAccountLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: isCreatingAccountLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: const BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40.0),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: const Text(
                            'create_account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 27.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ).tr(),
                        ),
                        const SizedBox(height: 30.0),
                        GestureDetector(
                          onTap: () {
                            _uploadImage();
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                child: _image != null
                                    ? ClipOval(
                                        child: Image.file(
                                          _image!,
                                          width: 120.0,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 70,
                                        color: Colors.grey.shade600,
                                      ),
                              ),
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 16.0,
                                  backgroundColor: Colors.indigo,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter_email'.tr();
                            }
                            return null;
                          },
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'email'.tr(),
                            labelText: "email".tr(),
                            hintStyle: const TextStyle(color: Colors.white54),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter_nname'.tr();
                            }
                            return null;
                          },
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'name'.tr(),
                            hintStyle: const TextStyle(color: Colors.white54),
                            labelText: "name".tr(),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        IntlPhoneField(
                          style: const TextStyle(color: Colors.white),
                          initialCountryCode: 'SA',
                          controller: _phoneController,
                          decoration: InputDecoration(
                            prefixStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                            counterStyle: const TextStyle(color: Colors.white),
                            border: const UnderlineInputBorder(),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            label: const Text(
                              'phone_number',
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                            hintText: 'phone_number'.tr(),
                            hintStyle: const TextStyle(color: Colors.white54),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () async {
                            Position position = await _determinePosition();
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                              position.latitude,
                              position.longitude,
                            );

                            setState(() {
                              locationData =
                                  "${placemarks[0].street} - ${placemarks[0].locality} - ${placemarks[0].administrativeArea} - ${placemarks[0].country}";
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 20.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                'access_current_location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ).tr(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          locationData,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'enter_password'.tr();
                            }
                            return null;
                          },
                          controller: _password,
                          decoration: InputDecoration(
                            hintText: 'password'.tr(),
                            labelText: 'password'.tr(),
                            hintStyle: const TextStyle(color: Colors.white54),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                Colors.indigo.shade500,
                                Colors.indigo.shade800,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _image != null) {
                                await validateSignup();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'fill_form_first',
                                      style: TextStyle(fontSize: 20),
                                    ).tr(),
                                  ),
                                );
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 20.0,
                              ),
                              child: const Text(
                                'sign_up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ).tr(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'already_have_account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ).tr(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return const LoginScreen();
                                }));
                              },
                              child: const Text(
                                'login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ).tr(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _uploadImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _imageUploaded = true;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.'.tr());
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true). According to Android guidelines,
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied'.tr());
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.'
            .tr(),
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
