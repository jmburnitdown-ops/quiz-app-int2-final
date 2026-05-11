import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _schoolIdController = TextEditingController();
  
  // NEW ACADEMIC CONTROLLERS
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        // Create Auth User
        UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save Extended Profile to Firestore
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'schoolId': _schoolIdController.text.trim(),
          'email': _emailController.text.trim(),
          'course': _courseController.text.trim(),
          'year': _yearController.text.trim(),
          'major': _majorController.text.trim(),
          'section': _sectionController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Auth Error')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(_isSignUp ? "Create Account" : "Welcome Back", 
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                if (_isSignUp) ...[
                  _buildField(_firstNameController, "First Name", Icons.person),
                  _buildField(_lastNameController, "Last Name", Icons.person_outline),
                  _buildField(_schoolIdController, "School ID", Icons.badge),
                  // NEW ACADEMIC FIELDS
                  _buildField(_courseController, "Course (e.g. BSIT)", Icons.school),
                  _buildField(_yearController, "Year Level", Icons.calendar_view_day),
                  _buildField(_majorController, "Major", Icons.star_border),
                  _buildField(_sectionController, "Section", Icons.group_work),
                ],
                _buildField(_emailController, "Email", Icons.email),
                _buildPasswordField(),
                const SizedBox(height: 20),
                if (_isLoading) 
                  const CircularProgressIndicator()
                else 
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: Text(_isSignUp ? "Register" : "Login"),
                  ),
                TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(_isSignUp ? "Already have an account? Login" : "New user? Create Account"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder()),
        validator: (v) => v!.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (v) => v!.length < 6 ? 'Min 6 chars' : null,
    );
  }
}