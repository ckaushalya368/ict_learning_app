import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';

void main() {
  runApp(const ICTLearningApp());
}

class ICTLearningApp extends StatelessWidget {
  const ICTLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ICT Learning App',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
