import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  RoundedButton({required this.onPressed, required this.text});

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  double _animationValue = 1.0;

  void _animateButton() {
    setState(() {
      _animationValue = 0.9;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _animationValue = 1.0;
      });
    });

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _animateButton,
      splashColor: Colors.green.withOpacity(0.5),
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_animationValue),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.red], // Define your gradient colors
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
