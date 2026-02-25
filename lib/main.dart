import 'package:flutter/material.dart';
import 'screens/logo_screen.dart';

void main() {
  runApp(const NotelyAIApp());
}

class NotelyAIApp extends StatelessWidget {
  const NotelyAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notely AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LogoScreen(),
    );
  }
}
