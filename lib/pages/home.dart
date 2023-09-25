import 'package:flutter/material.dart';
import 'package:weather_app/getweather.dart';
import 'package:google_fonts/google_fonts.dart';

class home extends StatelessWidget {
  double latitude;
  double longitude;

  home({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              latitude.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              longitude.toString(),
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 10),
            // Text(
            //   description,
            //   style: TextStyle(fontSize: 18),
            // ),
            // SizedBox(height: 20),
            // SvgPicture.network(
            //   // 'https://openweathermap.org/img/wn/$iconCode.svg',
            //   height: 100,
            //   width: 100,
            // ),
          ],
        ),
      ),
    );
  }
}
