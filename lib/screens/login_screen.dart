import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // [cite: 3]
import 'quiz_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>(); // [cite: 10]
  
  // Controllers for authentication and profile details [cite: 12, 13, 15, 16, 17]
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _schoolIdController = TextEditingController();
  
  bool _isLoading = false; // [cite: 18]
  bool _isSignUp = false; // [cite: 19]
  bool _obscurePassword = true; // [cite: 20]

  // Helper for showing feedback [cite: 21]
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green, // [cite: 25]
      ),
    );
  }

  // Handle Registration with Firestore Profile Storage [cite: 29]
  Future<void> _handleSignUp() async {
    if (_formkey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // 1. Create User in Firebase Auth [cite: 33, 34]
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // 2. Save Profile Details to Firestore linked by UID [cite: 39, 41]
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'firstName': _firstNameController.text.trim(), // [cite: 42]
          'lastName': _lastNameController.text.trim(), // [cite: 43]
          'schoolId': _schoolIdController.text.trim(), // [cite: 44]
          'email': _emailController.text.trim(), // [cite: 46]
          'createdAt': FieldValue.serverTimestamp(), // [cite: 47]
        });

        _showMessage("Account created successfully!"); // [cite: 48]
        if (mounted) _navigateToQuiz();
      } on FirebaseAuthException catch (e) {
        _showMessage(e.message ?? "Registration failed", isError: true); // [cite: 56]
      } finally {
        if (mounted) setState(() => _isLoading = false); // [cite: 58]
      }
    }
  }

  // Handle standard Login [cite: 62]
  Future<void> _handleLogin() async {
    if (_formkey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) _navigateToQuiz();
      } on FirebaseAuthException catch (e) {
        _showMessage("Invalid email or password", isError: true); // [cite: 76]
      } finally {
        if (mounted) setState(() => _isLoading = false); // [cite: 78]
      }
    }
  }

  void _navigateToQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const QuizScreen()), // [cite: 54, 74]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Create Account' : 'Secure Quiz Login')), // [cite: 85]
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0), // [cite: 87]
          child: Form(
            key: _formkey, // [cite: 89]
            child: Column(
              children: [
                const Icon(Icons.school_rounded, size: 80, color: Colors.blue), // [cite: 92]
                const SizedBox(height: 20),
                
                // Show profile fields only during Sign Up [cite: 93]
                if (_isSignUp) ...[
                  TextFormField(
                    controller: _firstNameController, // [cite: 95]
                    decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null, // [cite: 99]
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastNameController, // [cite: 102]
                    decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null, // [cite: 106]
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _schoolIdController, // [cite: 109]
                    decoration: const InputDecoration(
                      labelText: 'School ID',
                      hintText: 'e.g. 2022-POB-0281', // [cite: 112]
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null, // [cite: 115]
                  ),
                  const SizedBox(height: 12),
                ],

                TextFormField(
                  controller: _emailController, // [cite: 120]
                  decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null, // [cite: 123]
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController, // [cite: 127]
                  obscureText: _obscurePassword, // [cite: 128]
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility), // [cite: 134]
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword), // [cite: 135]
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null, // [cite: 136]
                ),
                const SizedBox(height: 24),
                
                if (_isLoading)
                  const CircularProgressIndicator() // [cite: 141]
                else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSignUp ? _handleSignUp : _handleLogin, // [cite: 147]
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // [cite: 150]
                      ),
                      child: Text(_isSignUp ? 'Register' : 'Login to Start'), // [cite: 151]
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isSignUp = !_isSignUp), // [cite: 158]
                    child: Text(_isSignUp 
                      ? 'Already have an account? Login' // [cite: 159]
                      : 'New user? Create an Account'), // [cite: 160]
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose(); // [cite: 165]
    _passwordController.dispose(); // [cite: 166]
    _firstNameController.dispose(); // [cite: 167]
    _lastNameController.dispose(); // [cite: 168]
    _schoolIdController.dispose(); // [cite: 170]
    super.dispose();
  }
}