import 'package:flutter/material.dart';

class HomeWorkerScreen extends StatefulWidget {
  const HomeWorkerScreen({super.key});

  @override
  State<HomeWorkerScreen> createState() => _HomeWorkerScreenState();
}

class _HomeWorkerScreenState extends State<HomeWorkerScreen> {
  @override
  Widget build(BuildContext context) {
return const Scaffold(
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,  // Center the text vertically
      children: [
        Text(
          "Client Screen\nYou are working for MTS Construction now",
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,  // Center the text horizontally
        ),
      ],
    ),
  ),
);
  }
}