import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Method to show the About Dialog with the developer list
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 10),
            Text("About Developers"),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Developed by:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              SizedBox(height: 10),
              Text("• GEAH NICHOLE BENOSA"),
              Text("• HEART WENNROSE MANGABLE"),
              Text("• ROWEZA CLATA"),
              Text("• MARIEL MARAVILLA"),
              Text("• TRIXIE ANN MONTAñO"),
              Text("• LYCHELLE MARTINEZ"),
              Text("• MAKC LOZANES"),
              Text("• JOHN MARK BANGUD"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // RE-ADDED: About Icon
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          var data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Profile Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 60, color: Colors.blue),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "${data['firstName']} ${data['lastName']}",
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(data['email'] ?? '', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _infoCard("School ID", data['schoolId'] ?? 'N/A', Icons.badge),
                      
                      // Academic Info Row 1
                      Row(
                        children: [
                          Expanded(child: _infoCard("Course", data['course'] ?? 'N/A', Icons.school)),
                          const SizedBox(width: 10),
                          Expanded(child: _infoCard("Year", data['year'] ?? 'N/A', Icons.calendar_today)),
                        ],
                      ),

                      // Academic Info Row 2
                      Row(
                        children: [
                          Expanded(child: _infoCard("Major", data['major'] ?? 'N/A', Icons.star_border)),
                          const SizedBox(width: 10),
                          Expanded(child: _infoCard("Section", data['section'] ?? 'N/A', Icons.group_work)),
                        ],
                      ),
                      
                      const Divider(height: 30),
                      _infoCard("Latest Quiz", data['lastQuizCategory'] ?? 'None', Icons.history),

                      const SizedBox(height: 20),
                      
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(builder: (context) => const LoginScreen()), 
                            (route) => false
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text("LOGOUT", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),

                      const SizedBox(height: 30),
                      
                      // Footer Credits
                      const Text(
                        "Developed by Team Integrative",
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "BENOSA • MANGABLE • CLATA • MARAVILLA • MONTAñO • MARTINEZ • LOZANES • BANGUD",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        leading: Icon(icon, color: Colors.blue[700], size: 22),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(
          value, 
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }
}