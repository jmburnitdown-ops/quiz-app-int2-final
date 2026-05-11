import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final List<String> members = const [
    'GEAH NICHOLE BENOSA',
    'HEART WENNROSE MANGABLE',
    'ROWEZA CLATA',
    'MARIEL MARAVILLA',
    'TRIXIE ANN MONTAÑO',
    'LYCHELLE MARTINEZ',
    'MAKC LOZANES',
    'JOHN MARK BANGUD',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Group Members'),
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(members[index], style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
