import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/certificate_service.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _cachedData;

  String _studentName(User? user, Map<String, dynamic> data) {
    final firstName = data['firstName']?.toString().trim() ?? '';
    final lastName = data['lastName']?.toString().trim() ?? '';
    final fullName = '$firstName $lastName'.trim();

    if (fullName.isNotEmpty) return fullName;
    if (user?.displayName?.trim().isNotEmpty ?? false) {
      return user!.displayName!.trim();
    }
    return user?.email?.split('@').first ?? 'Student';
  }

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

  List<String> _earnedCertificateCategories(Map<String, dynamic> data) {
    final allScores = data['all_scores'] as Map<String, dynamic>? ?? {};
    final earnedCertificates =
        data['earnedCertificates'] as Map<String, dynamic>? ?? {};
    final categories = <String>{
      ...allScores.keys,
      ...earnedCertificates.entries
          .where((entry) => entry.value == true)
          .map((entry) => entry.key),
    }.toList()
      ..sort();

    return categories;
  }

  void _showCertificates(BuildContext context, User? user) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
            final categories = _earnedCertificateCategories(data);
            final name = _studentName(user, data);

            if (categories.isEmpty) {
              return const SizedBox(
                height: 220,
                child: Center(child: Text("No certificates earned yet.")),
              );
            }

            return SafeArea(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                children: [
                  const Text(
                    "Earned Certificates",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...categories.map(
                    (category) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.workspace_premium,
                            color: AppColors.purple),
                        title: Text("$category Certificate"),
                        subtitle: const Text("Tap to view, print, or share"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          CertificateService.showCertificatePopup(
                              context, name, category);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Method to show the About Dialog with the developer list
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.purple),
            SizedBox(width: 10),
            Text("About Developers"),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Developed by:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Certificates',
            icon: const Icon(Icons.workspace_premium),
            onPressed: () => _showCertificates(context, user),
          ),
          // RE-ADDED: About Icon
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
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
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .snapshots(includeMetadataChanges: false),
          builder: (context, snapshot) {
            // Use cached data if available, or load from snapshot
            var data = _cachedData ??
                (snapshot.data?.data() as Map<String, dynamic>? ?? {});

            // Cache the data on first load
            if (snapshot.hasData && _cachedData == null) {
              _cachedData = snapshot.data!.data() as Map<String, dynamic>?;
            }

            if (!snapshot.hasData && _cachedData == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final allScores = data['all_scores'] as Map<String, dynamic>? ?? {};
            final certificates = _earnedCertificateCategories(data);

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header Profile Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
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
                          child: Icon(Icons.person,
                              size: 60, color: AppColors.purple),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "${data['firstName']} ${data['lastName']}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(data['email'] ?? '',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _infoCard("School ID", data['schoolId'] ?? 'N/A',
                            Icons.badge),

                        // Academic Info Row 1
                        Row(
                          children: [
                            Expanded(
                                child: _infoCard("Course",
                                    data['course'] ?? 'N/A', Icons.school)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _infoCard("Year", data['year'] ?? 'N/A',
                                    Icons.calendar_today)),
                          ],
                        ),

                        // Academic Info Row 2
                        Row(
                          children: [
                            Expanded(
                                child: _infoCard("Major",
                                    data['major'] ?? 'N/A', Icons.star_border)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _infoCard(
                                    "Section",
                                    data['section'] ?? 'N/A',
                                    Icons.group_work)),
                          ],
                        ),

                        const Divider(height: 30),
                        _infoCard("Latest Quiz",
                            data['lastQuizCategory'] ?? 'None', Icons.history),
                        _badgesCard(allScores),
                        _certificatesCard(context, user, certificates),

                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () async {
                            await StorageService().clearAll();
                            await FirebaseAuth.instance.signOut();
                            if (!context.mounted) return;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text("LOGOUT",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),

                        const SizedBox(height: 30),

                        // Footer Credits
                        const Text(
                          "Developed by Team Integrative",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "BENOSA • MANGABLE • CLATA • MARAVILLA • MONTAÑO • MARTINEZ • LOZANES • BANGUD",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 10),
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
        leading: Icon(icon, color: AppColors.purple, size: 22),
        title: Text(title,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(
          value,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _badgesCard(Map<String, dynamic> allScores) {
    final badgeEntries = allScores.entries
        .map((entry) {
          final scoreData = entry.value as Map<String, dynamic>? ?? {};
          return MapEntry(
              entry.key, scoreData['badge']?.toString() ?? 'No Badge');
        })
        .where((entry) => entry.value != 'No Badge')
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (badgeEntries.isEmpty) {
      return _infoCard("Badges", "No badges earned yet", Icons.military_tech);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.military_tech,
                    color: AppColors.purple, size: 22),
                const SizedBox(width: 12),
                const Text(
                  "Badges",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: badgeEntries.map((entry) {
                final color = _badgeColor(entry.value);
                return Chip(
                  avatar: Icon(Icons.workspace_premium, color: color, size: 18),
                  label: Text("${entry.key}: ${entry.value}"),
                  side: BorderSide(color: color),
                  backgroundColor: color.withValues(alpha: 0.12),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _certificatesCard(
      BuildContext context, User? user, List<String> certificates) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        leading: const Icon(Icons.workspace_premium,
            color: AppColors.purple, size: 22),
        title: const Text("Certificates",
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(
          certificates.isEmpty
              ? "No certificates earned yet"
              : "${certificates.length} earned",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showCertificates(context, user),
      ),
    );
  }
}
