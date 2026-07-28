import 'package:flutter/material.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const Ddx3xApp());
}

class Ddx3xApp extends StatelessWidget {
  const Ddx3xApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DDX3X',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

