import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../Constant/AppColor.dart';
import '../Services/otp.dart';
import 'change_password_screen.dart';

class OTPScreen extends StatefulWidget {
  final String email;

  const OTPScreen({super.key, required this.email});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();

  bool _isVerifying = false;
  String _verificationError = '';

  Future<void> _verifyOTP() async {
    setState(() {
      _isVerifying = true;
      _verificationError = '';
    });

    final String otpCode = _otpController.text;

    try {
      await OTPService.verifyResetCode(widget.email, otpCode);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangePasswordScreen(email: widget.email,)),
      );
    } catch (error) {
      setState(() {
        _verificationError = error.toString();
      });
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title_otp').tr(),
        backgroundColor: AppColor.AppColors,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'enter_otp'.tr(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.AppColors
              ),
              child: _isVerifying
                  ? const CircularProgressIndicator()
                  : Text('verify_otp'.tr()),
            ),
            if (_verificationError.isNotEmpty)
              Text(
                _verificationError,
                style: const TextStyle(color: AppColor.AppColors),
              ),
          ],
        ),
      ),
    );
  }
}
