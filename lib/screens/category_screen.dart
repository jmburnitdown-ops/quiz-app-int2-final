import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';
import 'profile_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<String> categories = const [
    'HTML', 'CSS', 'JAVASCRIPT', 'ANGULAR', 'DART', 
    'FLUTTER', 'REACT', 'PYTHON', 'C++', 'SWIFT'
  ]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const ProfileScreen())
            ), 
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 10, 
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.blueAccent,
            child: InkWell(
              // FIXED: Changed 'onPressed' to 'onTap' to resolve compilation error
              onTap: () {
                Provider.of<QuizProvider>(context, listen: false).selectCategory(categories[index]);
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const QuizScreen())
                );
              },
              child: Center(
                child: Text(
                  categories[index], 
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}