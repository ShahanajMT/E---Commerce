import 'dart:async';

import 'package:ecommerce/core/constants.dart';
import 'package:ecommerce/screens/homePage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotateanimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2), // Adjust the duration as needed
      vsync: this,
    );

    _rotateanimation = Tween<double>(
      begin: 0,
      end: 2 * 3.141592653589793, // 2 * pi for a full circle
    ).animate(_animationController);

    _animationController.repeat(); // Rotate indefinitely

    Timer(
      const Duration(seconds: 3), // Adjust the duration as needed
      () {
        _animationController.stop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: _rotateanimation,
                child: Image.network(
                  'https://imgs.search.brave.com/NT9QwKNz6eOStQSFNPbycRMLtIsQsCEuXfjmoHz3v8Q/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTAy/OTg5NTgyOC92ZWN0/b3Ivc2hvcHBpbmct/YmFnLXdpdGgtY2Fy/dC1sb2dvLWRlc2ln/bi1pbGx1c3RyYXRv/ci5qcGc_cz02MTJ4/NjEyJnc9MCZrPTIw/JmM9SEU4ZndUWTlG/bXFrRU1ZOXFJLU5G/ZVFFby1nMGN4RTV4/dTZfZnZaWnJZMD0',
                  width: 100,
                  height: 100,
                  
                ),
              ),

              const SizedBox(height: 30,),
              const Text('eCart', style: TextStyle(color: mainColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),)
            ],
          ),
          
        ),
        
      ),
      
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }
}
