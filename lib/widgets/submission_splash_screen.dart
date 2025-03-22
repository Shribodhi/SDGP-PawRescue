import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../screens/pet_adoption_home_page.dart';

class SubmissionSplashScreen extends StatefulWidget {
  const SubmissionSplashScreen({super.key});

  @override
  _SubmissionSplashScreenState createState() => _SubmissionSplashScreenState();
}

class _SubmissionSplashScreenState extends State<SubmissionSplashScreen> {
  bool showCheckMark = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showCheckMark = true;
      });
      Future.delayed(const Duration(seconds: 4), () { // Increased duration to 4 seconds
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PetAdoptionHomePage()),
              (Route<dynamic> route) => false,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!showCheckMark)
              const SpinKitFadingCircle(
                color: Colors.orange,
                size: 50.0,
              )
            else ...[
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50.0,
              ),
              const SizedBox(height: 20),
              const Text(
                'Submission Successful!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}