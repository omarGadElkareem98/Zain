import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../Constant/AppColor.dart';
import '../Services/otp.dart';
import 'LoginScreen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({super.key, required this.email});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isChangingPassword = false;
  String _changePasswordError = '';

  Future<void> _changePassword() async {
    setState(() {
      _isChangingPassword = true;
      _changePasswordError = '';
    });

    final String newPassword = _newPasswordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    try {
      if (newPassword != confirmPassword) {
        throw Exception("Passwords don't match".tr());
      }

      await OTPService.changePassword(widget.email, newPassword);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      setState(() {
        _changePasswordError = error.toString();
      });
    } finally {
      setState(() {
        _isChangingPassword = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('change_password').tr(),
        backgroundColor: AppColor.AppColors,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'new_password'.tr(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'confirm_password'.tr(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isChangingPassword ? null : _changePassword,
              child: _isChangingPassword
                  ? const CircularProgressIndicator()
                  : const Text('change_password').tr(),
            ),
            if (_changePasswordError.isNotEmpty)
              Text(
                _changePasswordError,
                style: const TextStyle(color: AppColor.AppColors),
              ),
          ],
        ),
      ),
    );
  }
}
