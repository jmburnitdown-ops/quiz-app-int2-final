import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for logout
import '../providers/quiz_provider.dart';
import 'profile_screen.dart'; // Added to enable navigation to profile
import 'login_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrative Programming Quiz'),
        actions: [
          // NEW: Profile Icon to see John Mark's info
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          // NEW: Quick Logout Icon
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: quiz.isFinished 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                const SizedBox(height: 10),
                Text('Final Score: ${quiz.score}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => quiz.resetQuiz(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart Quiz'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // UI Enhancement: Progress Bar
                LinearProgressIndicator(
                  value: (quiz.currentIndex + 1) / quiz.totalQuestions,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
                Text(
                  'Question ${quiz.currentIndex + 1} of ${quiz.totalQuestions}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                Text(
                  quiz.currentQuestion.text, 
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ...List.generate(
                  quiz.currentQuestion.options.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Matches Login UI
                      ),
                      onPressed: () => quiz.answerQuestion(index),
                      child: Text(
                        quiz.currentQuestion.options[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}