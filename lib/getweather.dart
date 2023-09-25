import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/pages/login.dart';
import 'package:weather_app/pages/selectLocation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/roundedbutton.dart';

class Location {
  double latitude;
  double longitude;

  Location({required this.latitude, required this.longitude});
}

class WeatherData {
  // final double latitude;
  // final double longitude;
  final double temperature;
  final double windSpeed;
  final DateTime time;
  final int isDay;

  WeatherData(
      {/*required this.latitude, required this.longitude,*/ required this.temperature,
      required this.windSpeed,
      required this.time,
      required this.isDay});
}

class MyApp extends StatelessWidget {
  final Location location; // Provide the location here

  MyApp({required this.location});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: WeatherScreen(location: location),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  final Location location;

  WeatherScreen({required this.location});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherData> weatherData;
  final locations =
  FirebaseFirestore.instance.collection('locations').doc('locations_l');




  @override
  void initState() {
    super.initState();
    weatherData = fetchWeatherData();
  }


  Future<WeatherData> fetchWeatherData() async {
    // final location = ModalRoute.of(context)!.settings.arguments as Location;
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${widget.location.latitude}&longitude=${widget.location.longitude}&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m'));
    // 'https://api.open-meteo.com/v1/forecast?latitude=15.2993&longitude=74.1240&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m'));

    Map jsonData = json.decode(response.body);
    final currentWeatherData = jsonData['current_weather'];
    final temperature = currentWeatherData['temperature'];
    final windSpeed = currentWeatherData['windspeed'];
    // final windDirection = currentWeatherData['winddirection'];
    final isDay = currentWeatherData['is_day'];
    final time = DateTime.parse(currentWeatherData['time']);

    return WeatherData(
      temperature: temperature.toDouble(),
      windSpeed: windSpeed.toDouble(),
      // windDirection: windDirection,
      // weatherCode: weatherCode,
      isDay: isDay,
      time: time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text('WeatherPro'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to your login screen
                );
              } catch (e) {
                print('Error logging out: $e');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<WeatherData>(
          future: weatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.oswald(fontSize: 18),
              );
            } else if (!snapshot.hasData) {
              return Text(
                'No weather data available',
                style: GoogleFonts.oswald(fontSize: 18),
              );
            } else {
              final weather = snapshot.data!;
              final isDay = weather.isDay;
              bool daytime = false;
              if (isDay == 1) {
                daytime = true;
              }


              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    daytime ? 'assets/day.json' : 'assets/night.json' ,
                    // 'assets/night.json',
                    width: 300,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 50),

                  Text(
                    'Temperature : ${weather.temperature} °C',
                    style: GoogleFonts.oswald(fontSize: 28, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Time: ${weather.time.toString()}',
                    style: GoogleFonts.oswald(fontSize: 26, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'WindSpeed: ${weather.windSpeed.toString()}',
                    style: GoogleFonts.oswald(fontSize: 26, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  // Image.asset(
                  //   daytime ? 'assets/day_image.png' : 'assets/night_image.png',
                  //   width: 200,
                  //   height: 200,
                  // ),
                  Text(
                    'Last Viewed Coordinates:',
                    style: GoogleFonts.oswald(fontSize: 24, color: Colors.white),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: locations.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          'Loading...',
                          style: GoogleFonts.oswald(fontSize: 20, color: Colors.white),
                        );
                      }
                      if (!snapshot.data!.exists) {
                        return Text(
                          'No data available',
                          style: GoogleFonts.oswald(fontSize: 20, color: Colors.white),
                        );
                      }
                      final lat = snapshot.data!.get('lat');
                      final long = snapshot.data!.get('long');

                      //
                      // final response_l = http.get(Uri.parse(
                      //     'https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${long}&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m'));
                      //

                      return Text(
                        'Latitude: $lat, Longitude: $long',

                        style: GoogleFonts.oswald(fontSize: 20, color: Colors.white),
                      );
                    },
                  ),

                 SizedBox(height: 20,),
                 RoundedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/selectlocation');
                    },
                    text: ('Select Coordinates'),
                  ),
                  // RoundedButton(
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, '/getweather, ');
                  //   },
                  //   text: ('View Weather for last viewed Coordinates'),
                  // ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
