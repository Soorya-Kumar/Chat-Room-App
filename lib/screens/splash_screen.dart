import 'package:flutter/material.dart';

class SplashScreeen extends StatelessWidget{
  const SplashScreeen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat Screen'),
        ),
        body: const Text("Loading IN.. Please Wait..."),
      ),
    );
  }
}