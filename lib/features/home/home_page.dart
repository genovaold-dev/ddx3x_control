import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'DDX3X Home',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}