import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practicef/main.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  final User? user;

  const SplashScreen({Key? key, this.child, this.user}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween(begin: 0.5, end: 1.0).animate(_controller);

    _controller.forward();

    // Use Timer to navigate after 3 seconds
    Timer(
      Duration(seconds: 3),
          () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
              (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset('assets/images/gg.jpg'),
        ),
      ),
    );
  }
}
