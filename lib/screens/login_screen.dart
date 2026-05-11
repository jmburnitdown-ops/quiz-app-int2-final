import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/security_service.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';

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
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final storage = StorageService();
      final email = SecurityService.sanitizeEmail(_emailController.text);
      final password = _passwordController.text;

      if (_isSignUp) {
        // 1. Create Auth User
        UserCredential cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 2. UPDATE AUTH DISPLAY NAME (This fixes your certificate name issue)
        String fullName =
            "${SecurityService.sanitizeInput(_firstNameController.text)} ${SecurityService.sanitizeInput(_lastNameController.text)}";
        await cred.user!.updateDisplayName(fullName);

        // 3. Save Extended Profile to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set({
          'firstName': SecurityService.sanitizeInput(_firstNameController.text),
          'lastName': SecurityService.sanitizeInput(_lastNameController.text),
          'schoolId': SecurityService.sanitizeInput(_schoolIdController.text),
          'email': email,
          'course': SecurityService.sanitizeInput(_courseController.text),
          'year': SecurityService.sanitizeInput(_yearController.text),
          'major': SecurityService.sanitizeInput(_majorController.text),
          'section': SecurityService.sanitizeInput(_sectionController.text),
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await storage.refreshAuthToken(cred.user, forceRefresh: true);
        await storage.recordSessionActivity();
      } else {
        final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        await storage.refreshAuthToken(cred.user, forceRefresh: true);
        await storage.recordSessionActivity();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Auth Error')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 12),
                child: Image.asset(
                  'assets/images/quiz_app_logo.png',
                  width: 52,
                  height: 52,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/quiz_app_logo.png',
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      _buildOutlinedTitle(
                          _isSignUp ? "Create Account" : "Welcome Back"),
                      const SizedBox(height: 30),
                      if (_isSignUp) ...[
                        _buildField(
                            _firstNameController, "First Name", Icons.person),
                        _buildField(_lastNameController, "Last Name",
                            Icons.person_outline),
                        _buildField(
                            _schoolIdController, "School ID", Icons.badge),
                        _buildField(_courseController, "Course (e.g. BSIT)",
                            Icons.school),
                        _buildField(_yearController, "Year Level",
                            Icons.calendar_view_day),
                        _buildField(
                            _majorController, "Major", Icons.star_border),
                        _buildField(
                            _sectionController, "Section", Icons.group_work),
                      ],
                      _buildField(
                        _emailController,
                        "Email",
                        Icons.email,
                        validator: _validateEmail,
                      ),
                      _buildPasswordField(),
                      const SizedBox(height: 20),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: AppColors.purple,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(_isSignUp ? "Register" : "Login"),
                        ),
                      TextButton(
                        onPressed: () => setState(() => _isSignUp = !_isSignUp),
                        child: Text(_isSignUp
                            ? "Already have an account? Login"
                            : "New user? Create Account"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    Color textColor = Colors.black,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        cursorColor: textColor,
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: AppColors.purple),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.purple, width: 2)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator ?? _validateRequiredText,
      ),
    );
  }

  String? _validateRequiredText(String? value) {
    if (SecurityService.sanitizeInput(value ?? '').isEmpty) return 'Required';
    return null;
  }

  String? _validateEmail(String? value) {
    if (!SecurityService.isValidEmail(value ?? '')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Required';
    if (!_isSignUp) return null;

    if (!SecurityService.isStrongPassword(password)) {
      return 'Use 8+ chars with upper, lower, and number';
    }
    return null;
  }

  Widget _buildOutlinedTitle(String text) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock, color: AppColors.purple),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.purple),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.purple, width: 2)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: _validatePassword,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _schoolIdController.dispose();
    _courseController.dispose();
    _yearController.dispose();
    _majorController.dispose();
    _sectionController.dispose();
    super.dispose();
  }
}
