import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Performance Analytics'), 
        backgroundColor: Colors.blue[700], 
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          var data = snapshot.data!.data() as Map<String, dynamic>?;
          var allScores = data?['all_scores'] as Map<String, dynamic>? ?? {};

          if (allScores.isEmpty) {
            return const Center(child: Text("No quiz history yet. Start a quiz!"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: allScores.length,
            itemBuilder: (context, index) {
              String category = allScores.keys.elementAt(index);
              var scoreData = allScores[category];
              double percent = (scoreData['score'] / scoreData['total']);

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.blueGrey.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          "${(percent * 100).toInt()}%", 
                          style: TextStyle(color: percent > 0.7 ? Colors.green : Colors.orange, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: percent,
                        minHeight: 10,
                        backgroundColor: Colors.grey[200],
                        color: percent > 0.7 ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("${scoreData['score']} / ${scoreData['total']} Points", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}