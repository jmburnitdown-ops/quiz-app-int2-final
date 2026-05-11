import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/quiz_provider.dart';
import '../services/certificate_service.dart';
import '../theme/app_colors.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _controller;
  bool _certificatePopupShown = false;

  Color _badgeColor(String badge) {
    switch (badge) {
      case 'Gold':
        return const Color(0xFFFFB300);
      case 'Silver':
        return const Color(0xFF90A4AE);
      case 'Bronze':
        return const Color(0xFFB87333);
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize controller to blast for 4 seconds (smoother animation)
    _controller = ConfettiController(duration: const Duration(seconds: 4));
    _controller.play();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCertificatePopupIfEligible();
    });
  }

  void _showCertificatePopupIfEligible() {
    if (!mounted || _certificatePopupShown) return;

    final quiz = Provider.of<QuizProvider>(context, listen: false);
    final int total = quiz.totalQuestions * QuizProvider.pointsPerCorrectAnswer;

    if (total == 0 || quiz.selectedCategory.isEmpty) return;

    _certificatePopupShown = true;

    final user = FirebaseAuth.instance.currentUser;
    final String studentName = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : user?.email?.split('@').first.trim() ?? 'Student';

    CertificateService.showCertificatePopup(
      context,
      studentName,
      quiz.selectedCategory,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<QuizProvider>(context, listen: false);
    final int score = quiz.score;
    final int total = quiz.totalQuestions * QuizProvider.pointsPerCorrectAnswer;
    final String badge = quiz.earnedBadge;
    final Color badgeColor = _badgeColor(badge);

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.purpleDark, AppColors.purpleLight],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "QUIZ COMPLETED!",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const Text("Your Score", style: TextStyle(fontSize: 18)),
                        Text(
                          "$score / $total",
                          style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: AppColors.purple),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: badgeColor, width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                badge == 'No Badge' ? Icons.workspace_premium_outlined : Icons.workspace_premium,
                                color: badgeColor,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    badge == 'No Badge' ? 'No Badge Earned' : '$badge Badge',
                                    style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${quiz.correctAnswers} correct answers',
                                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    quiz.resetQuiz();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.purple,
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text("Return to Home"),
                ),
              ],
            ),
          ),
          
          // ADVANCED UI: Confetti Blast (Replaces the slow Lottie)
          ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [AppColors.yellow, AppColors.cyan, Colors.white, AppColors.purpleLight],
            numberOfParticles: 25,
            gravity: 0.05,
            emissionFrequency: 0.02,
          ),
        ],
      ),
    );
  }
}
