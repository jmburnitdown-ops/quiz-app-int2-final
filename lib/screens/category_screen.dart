import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';
import 'leaderboard_screen.dart';
import '../theme/app_colors.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  // LINE 9: Removed 'const' from here to allow the Icon objects
  final List<Map<String, dynamic>> categories = const [
    {'name': 'HTML', 'icon': Icons.code},
    {'name': 'CSS', 'icon': Icons.brush},
    {'name': 'JAVASCRIPT', 'icon': Icons.javascript},
    {'name': 'ANGULAR', 'icon': Icons.layers},
    {'name': 'DART', 'icon': Icons.ads_click}, // LINE 17: Changed to a valid icon name
    {'name': 'FLUTTER', 'icon': Icons.flutter_dash},
    {'name': 'REACT', 'icon': Icons.reorder},
    {'name': 'PYTHON', 'icon': Icons.terminal},
    {'name': 'C++', 'icon': Icons.settings_applications},
    {'name': 'SWIFT', 'icon': Icons.phone_iphone},
  ];

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
        child: Column(
          children: [
            AppBar(
        title: const Text('Knowledge Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
              backgroundColor: AppColors.purple,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  tooltip: 'Performance Analytics',
                  icon: const Icon(Icons.bar_chart_rounded),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StatsScreen())),
                ),
                IconButton(
                  tooltip: 'Leaderboard',
                  icon: const Icon(Icons.emoji_events_rounded),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaderboardScreen())),
                ),
                IconButton(
                  tooltip: 'Profile',
                  icon: const Icon(Icons.person_outline_rounded),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.1,
        ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Hero(
                  tag: cat['name'],
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.purpleLight, AppColors.purpleDark],
                        ),
                      ),
                      child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Provider.of<QuizProvider>(context, listen: false).selectCategory(cat['name']);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'], size: 40, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        cat['name'],
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
            },
        ),
            ),
          ],
        ),
        ),
    );
  }
}
