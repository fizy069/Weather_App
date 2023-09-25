import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/pages/home.dart';
import 'package:weather_app/pages/login.dart';
import 'package:weather_app/pages/Splash screen.dart';
import 'package:weather_app/pages/selectLocation.dart';
import 'getweather.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Location location = Location(latitude: 15.2993, longitude: 74.1240);


  return runApp(MaterialApp(

    initialRoute: '/login',
    routes: {
      // '/': (context) => SplashScreen(),
      //shows GOA WEATHER DATA by default
      // '/home': (context) => home(latitude: 15.2993,longitude: 74.1240),
      '/login' : (context) => LoginPage(),
      '/getweather': (context) => WeatherScreen(location: location),
      '/selectlocation' : (context) => LocationInputPage(),
    },
  ));
}

