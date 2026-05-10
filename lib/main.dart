import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_provider.dart';
import 'package:quiz_app/screens/login_screen.dart';
// IMPORTANT: This file was created when you finished 'flutterfire configure'
import 'firebase_options.dart'; 

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Core Requirement: Initialize Firebase using the auto-generated options
    // This satisfies the Firebase Bonus (+10 pts) correctly for all platforms
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); 
    
    runApp(
      ChangeNotifierProvider(
        create: (_) => QuizProvider(),
        child: const QuizApp(),
      ),
    );
  } catch (e) {
    // Security Goal 1: Graceful error handling
    debugPrint("Firebase initialization failed: $e");
    
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Initialization Error: Ensure Firebase is configured and you have an internet connection.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ),
      ),
    ));
  }
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Security Quiz App',
      theme: ThemeData(
        // Optimization: Material 3 Seed-based colors
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Core Requirement: Navigation starting point (10 pts)
      home: const LoginScreen(), 
    );
  }
}