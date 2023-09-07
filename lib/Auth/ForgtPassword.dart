


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../Constant/AppColor.dart';
import '../Services/otp.dart';
import 'otp_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.AppColors,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text('title_forgot',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),).tr(),
                SizedBox(height: 20,),
                Text('description').tr(),
                SizedBox(height: 30,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'your_email'.tr(),

                      border: OutlineInputBorder(

                      ),

                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.AppColors),
                          borderRadius: BorderRadius.circular(14)
                      )
                  ),


                ),
                SizedBox(height: 15,),



                SizedBox(height: 15,),
                Container(
                  width: double.infinity,

                  child: MaterialButton(
                    onPressed: ()async{
                      try{
                        await OTPService.sendResetCode(_emailController.text);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => OTPScreen(email: _emailController.text,))
                        );
                      }catch(err){

                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('send',style:TextStyle(color: Colors.white,fontSize: 20) ,).tr(),
                    ),
                    color: AppColor.AppColors,


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
