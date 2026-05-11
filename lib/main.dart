import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Required for StreamBuilder
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/quiz_provider.dart';
import 'screens/login_screen.dart';
import 'screens/category_screen.dart'; // Required to navigate to home
import 'services/storage_service.dart';
import 'theme/app_colors.dart';

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
        builder: (context, child) {
          return Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => StorageService().recordSessionActivity(),
            child: child ?? const SizedBox.shrink(),
          );
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.purple,
            primary: AppColors.purple,
            secondary: AppColors.cyan,
            tertiary: AppColors.yellow,
            surface: AppColors.softWhite,
          ),
          scaffoldBackgroundColor: Colors.transparent,
          useMaterial3: true,
        ),
        // UPDATED: Use StreamBuilder to manage login state automatically
        home: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.purple,
                AppColors.purpleLight,
                AppColors.yellow,
              ],
            ),
          ),
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // While Firebase is checking the connection, show a loading spinner
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // If the snapshot has data, it means a user is logged in
              if (snapshot.hasData) {
                return const SessionGuard(child: CategoryScreen());
              }

              // Otherwise, show the Login Screen
              return const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}

class SessionGuard extends StatefulWidget {
  const SessionGuard({super.key, required this.child});

  final Widget child;

  @override
  State<SessionGuard> createState() => _SessionGuardState();
}

class _SessionGuardState extends State<SessionGuard>
    with WidgetsBindingObserver {
  final StorageService _storage = StorageService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startSession();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _enforceSessionSecurity(),
    );
  }

  Future<void> _startSession() async {
    await _storage.recordSessionActivity();
    await _storage.refreshAuthToken(
      FirebaseAuth.instance.currentUser,
      forceRefresh: true,
    );
  }

  Future<void> _enforceSessionSecurity() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (await _storage.isSessionExpired()) {
      await _storage.clearAll();
      await FirebaseAuth.instance.signOut();
      return;
    }

    await _storage.refreshAuthToken(user);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enforceSessionSecurity();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
