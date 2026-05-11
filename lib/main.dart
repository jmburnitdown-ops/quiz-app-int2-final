import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Required for StreamBuilder
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/quiz_provider.dart';
import 'screens/login_screen.dart';
import 'screens/category_screen.dart'; // Required to navigate to home

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initializes Firebase for Auth and Firestore
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Links the QuizProvider to the app for category and score management
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: MaterialApp(
        title: 'Integrative Programming Quiz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // UPDATED: Use StreamBuilder to manage login state automatically
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // While Firebase is checking the connection, show a loading spinner
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            
            // If the snapshot has data, it means a user is logged in
            if (snapshot.hasData) {
              return const CategoryScreen();
            }
            
            // Otherwise, show the Login Screen
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}