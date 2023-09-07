import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zainlak_tech/Auth/LoginScreen.dart';
import 'package:zainlak_tech/Screen/Ui/MainScreen.dart';

class OnboardingScreen extends StatelessWidget {
  final String? token;
  OnboardingScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: [
          PageViewModel(
            title: "مرحبا بك في زين التنموية",
            // body: ,
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                _buildImageWidget("assets/icon/one.jpg"),
              ],
            ),decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: "اعثر علي فنيين بسهولة",
            // body: ,
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageWidget("assets/icon/one.jpg"),
              ],
            ),
            decoration: _getPageDecoration(),
          ),
          PageViewModel(
            title: "ابدأ الان",
            // body: ,
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageWidget("assets/icon/one.jpg"),
              ],
            ),
            decoration: _getPageDecoration(),
          ),
        ],
        onDone: () {
          // Navigate to the HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => token == null ? LoginScreen() : MainScreen(),
            ),
          );
        },
        done: Text(
          "Get Started",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        showSkipButton: true,
        skip: Text("Skip",),
        next: Icon(Icons.arrow_forward),
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
    );
  }

  PageDecoration _getPageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(fontSize: 20.0),
      imagePadding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      pageColor: Colors.white,
    );
  }
}
