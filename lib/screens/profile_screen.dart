import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(), // [cite: 291]
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || !snapshot.data!.exists) return const Center(child: Text("No profile data found."));

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                const SizedBox(height: 20),
                ListTile(title: const Text("Full Name"), subtitle: Text("${data['firstName']} ${data['lastName']}"), leading: const Icon(Icons.badge)), // [cite: 308, 309]
                ListTile(title: const Text("School ID"), subtitle: Text(data['schoolId'] ?? "N/A"), leading: const Icon(Icons.school)), // [cite: 313, 314]
                ListTile(title: const Text("Email"), subtitle: Text(data['email'] ?? "N/A"), leading: const Icon(Icons.email)), // [cite: 318, 319]
                const Divider(height: 40),
                const Text("Latest Quiz Performance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // [cite: 326, 327]
                const SizedBox(height: 10),
                ListTile(
                  title: const Text("Category"),
                  subtitle: Text(data['lastQuizCategory'] ?? "No quiz taken yet"),
                  leading: const Icon(Icons.category, color: Colors.blue),
                ),
                ListTile(
                  title: const Text("Recent Score"),
                  subtitle: Text(data['lastQuizScore'] != null ? "${data['lastQuizScore']} points" : "0 points"),
                  leading: const Icon(Icons.emoji_events, color: Colors.amber),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false); // [cite: 353, 355]
                    }
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}