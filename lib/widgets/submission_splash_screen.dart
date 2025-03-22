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
    // After 5 seconds, show the success checkmark
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showCheckMark = true;
      });

      // Navigate back to home page after showing success for 1 second
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PetAdoptionHomePage()),
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
            else
              const Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80.0,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Submission Successful!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}