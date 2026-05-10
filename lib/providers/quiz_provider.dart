import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/storage_service.dart';

class QuizProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  
  int _currentIndex = 0;
  int _score = 0;
  bool _isFinished = false;
  int _highScore = 0;
  
  // Security Feature: Use a constant for points to prevent accidental logic errors
  static const int pointsPerCorrectAnswer = 10;

  final List<Question> _questions = [
    Question(
      id: '1',
      text: 'Which Flutter command builds a release App Bundle?',
      options: ['flutter run', 'flutter build apk', 'flutter build appbundle', 'flutter install'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: '2',
      text: 'Where should sensitive API keys be stored?',
      options: ['Hardcoded in code', 'Shared Preferences', 'Secure Storage', 'Text file'],
      correctAnswerIndex: 2,
    ),
  ];

  // Getters
  int get score => _score;
  int get highScore => _highScore;
  int get currentIndex => _currentIndex;
  bool get isFinished => _isFinished;
  Question get currentQuestion => _questions[_currentIndex];
  int get totalQuestions => _questions.length;

  QuizProvider() {
    _loadHighScore();
  }

  // Goal 1: Security - Securely read data from encrypted storage
  Future<void> _loadHighScore() async {
    try {
      final savedScore = await _storage.getHighScore();
      if (savedScore != null) {
        // Validation: Ensure the data read is a valid integer
        _highScore = int.tryParse(savedScore) ?? 0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Security Warning: Error reading secure storage: $e");
    }
  }

  void answerQuestion(int selectedIndex) {
    // Security Feature: Input validation on the index
    if (selectedIndex < 0 || selectedIndex >= currentQuestion.options.length) return;

    // Score validation logic (Goal 1: Logic Integrity)
    if (selectedIndex == currentQuestion.correctAnswerIndex) {
      _score += pointsPerCorrectAnswer;
    }

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
    } else {
      _isFinished = true;
      _handleEndOfQuiz(); 
    }
    notifyListeners();
  }

  Future<void> _handleEndOfQuiz() async {
    if (_score > _highScore) {
      _highScore = _score;
      // Goal 1: Encrypt sensitive data at rest using Secure Storage
      await _storage.saveHighScore(_score); 
    }
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _isFinished = false;
    notifyListeners();
  }
}