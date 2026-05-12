import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    
    // We use 'allQuestions' to match the getter in your QuizProvider
    final questions = quizProvider.allQuestions[quizProvider.selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Review Your Answers"),
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: questions.isEmpty
          ? const Center(child: Text("No questions to review."))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                
                // Safety check for user answers list
                final int? userAnswer = quizProvider.userAnswers.length > index 
                    ? quizProvider.userAnswers[index] 
                    : null;
                    
                final bool isCorrect = userAnswer == question.correctAnswerIndex;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Header
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isCorrect ? Colors.green[100] : Colors.red[100],
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: isCorrect ? Colors.green[800] : Colors.red[800],
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                question.text,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 25),
                        
                        // Status information
                        if (userAnswer == null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange.withOpacity(0.5)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.help_outline, size: 18, color: Colors.orange[700]),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Not answered',
                                    style: TextStyle(
                                      color: Colors.orange[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                        // Options List
                        ...List.generate(question.options.length, (optionIndex) {
                          bool isThisCorrectOption = optionIndex == question.correctAnswerIndex;
                          bool isThisUserChoice = optionIndex == userAnswer;

                          // UI Logic for colors and icons
                          Color boxColor = Colors.transparent;
                          Color textColor = Colors.black87;
                          IconData? trailingIcon;

                          // Correct answer - always green
                          if (isThisCorrectOption) {
                            boxColor = Colors.green.withOpacity(0.15);
                            textColor = Colors.green[700]!;
                            trailingIcon = Icons.check_circle;
                          }
                          // User's wrong choice - red
                          else if (isThisUserChoice && !isCorrect) {
                            boxColor = Colors.red.withOpacity(0.15);
                            textColor = Colors.red[700]!;
                            trailingIcon = Icons.cancel;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: boxColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: boxColor != Colors.transparent 
                                    ? textColor.withOpacity(0.4) 
                                    : Colors.grey[300]!,
                                width: boxColor != Colors.transparent ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${optionIndex + 1}.",
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    question.options[optionIndex],
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: isThisUserChoice || isThisCorrectOption 
                                          ? FontWeight.w600 
                                          : FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (trailingIcon != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Icon(trailingIcon, size: 20, color: textColor),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
