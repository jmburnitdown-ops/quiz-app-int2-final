import 'package:quiz_app/models/question.dart';
import 'package:test/test.dart';

void main() {
  group('Question', () {
    test('stores the question id', () {
      final question = Question(
        id: 'html-1',
        text: 'What does HTML stand for?',
        options: ['A', 'B', 'C', 'D'],
        correctAnswerIndex: 1,
      );

      expect(question.id, 'html-1');
    });

    test('stores the question text', () {
      final question = Question(
        id: 'css-1',
        text: 'What does CSS stand for?',
        options: ['A', 'B', 'C', 'D'],
        correctAnswerIndex: 2,
      );

      expect(question.text, 'What does CSS stand for?');
    });

    test('stores all answer options in order', () {
      final question = Question(
        id: 'dart-1',
        text: 'Entry point of a Dart app?',
        options: ['start()', 'run()', 'main()', 'init()'],
        correctAnswerIndex: 2,
      );

      expect(question.options, ['start()', 'run()', 'main()', 'init()']);
    });

    test('stores the correct answer index', () {
      final question = Question(
        id: 'flutter-1',
        text: 'Language used for Flutter?',
        options: ['Java', 'Swift', 'Dart', 'Kotlin'],
        correctAnswerIndex: 2,
      );

      expect(question.correctAnswerIndex, 2);
    });

    test('can resolve the correct answer from options', () {
      final question = Question(
        id: 'python-1',
        text: 'Keyword creates a function?',
        options: ['function', 'def', 'fun', 'define'],
        correctAnswerIndex: 1,
      );

      expect(question.options[question.correctAnswerIndex], 'def');
    });
  });
}
