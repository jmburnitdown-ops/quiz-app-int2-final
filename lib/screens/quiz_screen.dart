import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'results_screen.dart';
import '../theme/app_colors.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<QuizProvider>(context);

    // ADVANCED UI: Auto-navigate to results when finished
    if (quiz.isFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResultsScreen()));
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('${quiz.selectedCategory} Quiz'),
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
      ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            LinearProgressIndicator(
              value: (quiz.currentIndex + 1) / quiz.totalQuestions,
              color: AppColors.cyan,
              backgroundColor: AppColors.yellow.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 20),
            // ADVANCED UI: Smooth transition between questions
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Text(
                quiz.currentQuestion.text,
                key: ValueKey<int>(quiz.currentIndex),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    const Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black),
                    const Shadow(offset: Offset(-1, -1), blurRadius: 2, color: Colors.black),
                    const Shadow(offset: Offset(1, -1), blurRadius: 2, color: Colors.black),
                    const Shadow(offset: Offset(-1, 1), blurRadius: 2, color: Colors.black),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ...List.generate(
              quiz.currentQuestion.options.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => quiz.answerQuestion(index),
                  child: Text(quiz.currentQuestion.options[index], style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
