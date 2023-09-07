import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool isLoading = false;

  GlobalKey<FormState> _formKey = GlobalKey();

  void NavigateToRegiserScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RegisterScreen();
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

      if(result != null){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }else{
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                child: Text('Wrong Email Or Password').tr(),
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
                    style: TextStyle(
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
              child: Text('Wrong Email Or Password').tr(),
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
                  style: TextStyle(
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Container(
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: AppColor.AppColors,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "خدمات بيتك في ايدك".tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ' Enter your email'.tr();
                      }
                    },
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'email'.tr(),
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'email'.tr(),

                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _password,
                    style: TextStyle(color: Colors.white),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'password is empty'.tr();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'password'.tr(),
                      hintStyle: TextStyle(color: Colors.white),
                      labelText: "password".tr(),
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) {
                          return ForgotPassword();
                        }),
                      );
                    },
                    child: Text(
                      'forget_password'.tr(),
                      style: TextStyle(color: AppColor.AppColors,fontSize: 20),
                    ).tr(),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await validateLogin();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ).tr(),
                      ),
                      color: AppColor.AppColors,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
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
                                return RegisterScreen();
                              }));
                        },
                        child: Text(
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
