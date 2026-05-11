import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  int _bestScore(Map<String, dynamic> user) {
    final allScores = user['all_scores'] as Map<String, dynamic>? ?? {};
    final categoryScores = allScores.values
        .whereType<Map<String, dynamic>>()
        .map((scoreData) => scoreData['score'])
        .whereType<num>()
        .map((score) => score.toInt());

    final lastQuizScore = user['lastQuizScore'];
    final scores = [
      if (lastQuizScore is num) lastQuizScore.toInt(),
      ...categoryScores,
    ];

    if (scores.isEmpty) return 0;
    return scores.reduce((best, score) => score > best ? score : best);
  }

  String _displayName(Map<String, dynamic> user) {
    final firstName = user['firstName']?.toString().trim() ?? '';
    final lastName = user['lastName']?.toString().trim() ?? '';
    final fullName = '$firstName $lastName'.trim();

    if (fullName.isNotEmpty) return fullName;
    return user['email']?.toString().split('@').first ?? 'Player';
  }

  bool _isActiveAccount(Map<String, dynamic> user) {
    final isActive = user['isActive'];
    final active = user['active'];
    final isDeleted = user['isDeleted'];
    final deleted = user['deleted'];
    final disabled = user['disabled'];
    final status = user['status']?.toString().toLowerCase().trim();

    return isActive != false &&
        active != false &&
        isDeleted != true &&
        deleted != true &&
        disabled != true &&
        user['deletedAt'] == null &&
        status != 'deleted' &&
        status != 'inactive' &&
        status != 'disabled';
  }

  Color _rankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFB300);
      case 1:
        return const Color(0xFF90A4AE);
      case 2:
        return const Color(0xFFB87333);
      default:
        return AppColors.cyan.withValues(alpha: 0.25);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Global Leaderboard"),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .where((user) => _isActiveAccount(user) && _bestScore(user) > 0)
                .toList()
              ..sort((a, b) => _bestScore(b).compareTo(_bestScore(a)));

            final topUsers = users.take(10).toList();

            if (topUsers.isEmpty) {
              return const Center(child: Text("No leaderboard scores yet."));
            }

            return Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: topUsers.length,
                itemBuilder: (context, index) {
                  final user = topUsers[index];
                  final score = _bestScore(user);
                  final course = user['course']?.toString().trim();

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _rankColor(index),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(_displayName(user)),
                    subtitle: Text((course == null || course.isEmpty)
                        ? "Best quiz score"
                        : "Course: $course"),
                    trailing: Text(
                      "$score pts",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.purple),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
