import 'package:flutter/material.dart';

class ChapterScreen extends StatelessWidget {
  const ChapterScreen({super.key, required this.unitTitle});

  final String unitTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A13),
      appBar: AppBar(
        title: Text(unitTitle),
        backgroundColor: const Color(0xFF191A2A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Chapters',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sample chapter — more content will be added.',
            style: TextStyle(color: Color(0xFF9295B1)),
          ),
          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF191A2A),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFFAE78FF),
              ),
              title: const Text(
                'Introduction',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Read chapter',
                style: TextStyle(color: Color(0xFF9295B1)),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Color(0xFF9295B1),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => NoteScreen(unitTitle: unitTitle),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key, required this.unitTitle});

  final String unitTitle;

  String get content {
    switch (unitTitle) {
      case 'Computer Architecture':
        return 'Computer architecture describes how the main parts of a '
            'computer work together.\n\n'
            'CPU\n'
            'The CPU executes instructions. Its main components include '
            'the control unit, arithmetic logic unit and registers.\n\n'
            'Memory\n'
            'RAM temporarily stores programs and data currently in use. '
            'Its contents are normally lost when power is turned off.\n\n'
            'Storage\n'
            'Devices such as SSDs retain data even when power is off.';

      case 'Data Structures & Algorithms':
        return 'A data structure organizes data so a program can use it '
            'effectively.\n\n'
            'Examples include arrays, linked lists, stacks and queues.\n\n'
            'An algorithm is a sequence of steps used to solve a problem. '
            'Searching and sorting are common examples.';

      case 'Internet & Networking':
        return 'A computer network connects devices so they can exchange '
            'data and share resources.\n\n'
            'A LAN connects devices within a limited area. '
            'The Internet connects networks around the world.\n\n'
            'Protocols define rules for communication between devices.';

      case 'Database Management':
        return 'A database stores related data in an organized form.\n\n'
            'A database management system helps users create, retrieve '
            'and update that data.\n\n'
            'In a relational database, tables contain rows and columns. '
            'A primary key uniquely identifies each row.';

      case 'Software Engineering':
        return 'Software engineering applies systematic methods to '
            'develop and maintain software.\n\n'
            'Typical activities include requirements analysis, design, '
            'implementation, testing and maintenance.';

      default:
        return 'Sustainable computing aims to reduce the environmental '
            'impact of technology.\n\n'
            'Examples include using energy-efficient equipment, '
            'extending device lifetimes and recycling electronic waste.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A13),
      appBar: AppBar(
        title: const Text('Introduction'),
        backgroundColor: const Color(0xFF191A2A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              unitTitle,
              style: const TextStyle(color: Color(0xFFAE78FF), fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Text(
              'Introduction',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SelectableText(
              content,
              style: const TextStyle(
                color: Color(0xFFD5D7E6),
                fontSize: 16,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
