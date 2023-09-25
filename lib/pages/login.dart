import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/pages/home.dart';
import 'package:weather_app/roundedbutton.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/pages/selectLocation.dart';
import 'package:weather_app/getweather.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _showErrorPopup(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (userCredential.user != null) {
        Location location = Location(latitude: 15.2993, longitude: 74.1240);
        // Navigator.pushReplacementNamed(context, '/getweather', location: location);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherScreen(location: location),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showErrorPopup('Invalid email or password. Please try again.: $e');

      // print("Error during email and password sign-in: $e");
    }
  }

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
        _showErrorPopup('Signed Up Successfully!');
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorPopup('Invalid email or password. Please try again - $e');

      // print("Error during email and password sign-up: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(), // Use dark theme for the app
      home: Scaffold(

        appBar: AppBar(
          title: const Text(
            'WeatherPro',
            style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    Lottie.asset(
                    'assets/animation_llhuqgxc.json', // Replace with your animation file path
                    width: 200,
                    height: 200,
                    // fit: BoxFit.cover,
                    ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          fillColor: Colors.white,
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          fillColor: Colors.white,
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      RoundedButton(
                        onPressed: _signInWithEmailAndPassword,
                        text: ('Sign In'),
                      ),
                      SizedBox(height: 10),
                      RoundedButton(
                        onPressed: _signUpWithEmailAndPassword,
                        text: ('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
