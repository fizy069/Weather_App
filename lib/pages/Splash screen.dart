import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/roundedbutton.dart';
import '../getweather.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WeatherNow',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Lottie.asset(
                'assets/weather2.json',
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(height: 20.0),
            RoundedButton(
              onPressed: () {
                // fetchweather(),
              },
              text: 'Select a Country',
            )
          ],
        ),
      ),
    );
  }
}
