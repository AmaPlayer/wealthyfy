import 'package:flutter/material.dart';
import 'package:wealthyfy/helper/colors.dart';
import 'package:wealthyfy/helper/imagees.dart';
import 'package:wealthyfy/helper/textview.dart';
import '../controller/button_controller/custombuttom.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.WHITECOLOR,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 75,right: 20,left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child:
              Image.asset(AppLogo,height: 320,),
            ),
            addPadding(50, 0),
            headingText(
                title: 'Hello! Wealthyfy Team', fontWeight: FontWeight.bold, fontSize: 20),
            addPadding(80, 0),
            CustomButton(
              text: 'Login',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },),
            addPadding(20, 0),
          ],
        ),
      ),
    );
  }
}
