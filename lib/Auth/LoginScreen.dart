import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../Constant/AppColor.dart';
import '../Screen/Ui/MainScreen.dart';
import '../Services/users.dart';
import 'ForgtPassword.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  void NavigateToRegiserScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const RegisterScreen();
    }));
  }

  Future<void> validateLogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      String email = _emailController.text;
      String password = _password.text;
      String phone = _phoneController.text;
      Map? result = await UserService.login(email, password);

      setState(() {
        isLoading = false;
      });

      if (result != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                child: const Text('Wrong Email Or Password').tr(),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black12,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ok'.tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: const Text('Wrong Email Or Password').tr(),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black12,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ok'.tr(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.indigo.shade300,
                    Colors.indigo.shade900,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Zainlak'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: AppColor.AppColors,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "خدمات بيتك في ايدك".tr(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' Enter your email'.tr();
                            }
                            return null;
                          },
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'email'.tr(),
                            hintStyle: const TextStyle(color: Colors.white),
                            labelStyle: const TextStyle(color: Colors.white),
                            labelText: 'email'.tr(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(33)),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: _password,
                          style: const TextStyle(color: Colors.white),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'password is empty'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'password'.tr(),
                            hintStyle: const TextStyle(color: Colors.white),
                            labelText: "password".tr(),
                            labelStyle: const TextStyle(color: Colors.white),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(33),
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) {
                                return const ForgotPassword();
                              }),
                            );
                          },
                          child: Text(
                            'forget_password'.tr(),
                            style: const TextStyle(
                                color: AppColor.AppColors, fontSize: 20),
                          ).tr(),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await validateLogin();
                              }
                            },
                            color: AppColor.AppColors,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: const Text(
                                'login',
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
                              'dont_have_account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ).tr(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return const RegisterScreen();
                                }));
                              },
                              child: const Text(
                                'sign_up',
                                style: TextStyle(
                                  color: AppColor.AppColors,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
}
