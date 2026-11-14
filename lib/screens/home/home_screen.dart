import 'package:flutter/material.dart';

import '../notes/notes_screen.dart';
import '../quiz/quiz_screen.dart';
import '../quiz/group_arena_screen.dart';
import '../profile/profile_screen.dart';
import '../lessons/buy_lessons_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const background = Color(0xFF090A13);
  static const surface = Color(0xFF191A2A);
  static const muted = Color(0xFF9295B1);
  static const purple = Color(0xFF8B46FF);
  static const cyan = Color.fromARGB(255, 48, 108, 114);
  static const outline = Color(0xFF2A2B3C);

  void _onTap(BuildContext context, String name) {
    if (name == 'Buy Lessons') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const BuyLessonsScreen()));
      return;
    }
    if (name.trim() == 'Buy Lesson' || name.trim() == 'Buy Lessons') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const BuyLessonsScreen()));
      return;
    }
    if (name == 'Group Arena' || name == 'Arena') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const GroupArenaScreen()));
      return;
    }
    if (name == 'Start Quiz') {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const QuizScreen()));
      return;
    }

    final opensNotes = [
      'Notes',
      'Module Notes',
      'Past Papers',
      'Database Management',
      '2023 A/L ICT Paper',
      'Computer Architecture',
      'Data Structures',
      'Internet & Networks',
    ].contains(name);

    if (opensNotes) {
      final showPapers = name == 'Past Papers' || name == '2023 A/L ICT Paper';

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => NotesScreen(initialTab: showPapers ? 1 : 0),
        ),
      );
      return;
    }

    const messages = {
      'Today’s Tasks': 'No tasks are available yet.',
      'Buy Lessons': 'Lesson purchases are coming soon.',
      'Payment History': 'Payment history is coming soon.',
    };

    if (name == 'Profile' || messages.containsKey(name)) {
      final user = FirebaseAuth.instance.currentUser;
      final displayName = user?.displayName?.trim() ?? '';
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            backgroundColor: background,
            appBar: AppBar(
              title: Text(name),
              backgroundColor: surface,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  name == 'Profile'
                      ? "${displayName.isEmpty ? 'Student' : displayName}\n${user?.email ?? ''}"
                      : messages[name]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$name screen coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 0.7,
                colors: [Color(0xFF281249), background],
                stops: [0, 0.65],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good morning, ☀️',
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.userChanges(),
                            builder: (context, snapshot) {
                              final user =
                                  snapshot.data ??
                                  FirebaseAuth.instance.currentUser;
                              final name = user?.displayName?.trim() ?? '';

                              return Text(
                                name.isEmpty ? 'Welcome!' : name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            ' ICT ',
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
                          const SizedBox(height: 24),
                          _heading('Quick Actions'),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _action(
                                  context,
                                  '⚡',
                                  'Start Quiz',
                                  'Random practice',
                                  featured: true,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _action(
                                  context,
                                  '📋',
                                  'Past Papers',
                                  '2019 – 2023',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _action(
                                  context,
                                  '🎯',
                                  'My Weaknesses',
                                  '3 areas flagged',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _action(
                                  context,
                                  '👥',
                                  'Group Arena',
                                  '4 players online',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          _heading('Learning & Account'),
                          const SizedBox(height: 14),
                          for (final (icon, title, subtitle) in const [
                            ('📅', 'Today’s Tasks', 'View daily tasks'),
                            ('📚', 'Module Notes', 'Browse ICT notes'),
                            ('🛒', 'Buy Lessons', 'Explore paid lessons'),
                            ('🧾', 'Payment History', 'View past payments'),
                            ('👤', 'Profile', 'View account details'),
                          ]) ...[
                            SizedBox(
                              width: double.infinity,
                              child: _action(context, icon, title, subtitle),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _navigation(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heading(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: outline),
    );
  }

  Widget _action(
    BuildContext context,
    String emoji,
    String title,
    String subtitle, {
    bool featured = false,
  }) {
    return Container(
      decoration: featured
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8235EF), Color(0xFF5920B5)],
              ),
            )
          : _decoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _onTap(context, title),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: featured ? const Color(0xFFCFB4FF) : muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navigation(BuildContext context) {
    const labels = ['Home', 'Notes', 'Arena', 'Buy Lesson', 'Profile'];

    const icons = [
      Icons.home_outlined,
      Icons.menu_book_rounded,
      Icons.bolt_rounded,
      Icons.shopping_bag_outlined,
      Icons.account_circle_outlined,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF10111D),
        border: Border(top: BorderSide(color: outline)),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == 0;

          return Expanded(
            child: InkWell(
              onTap: () {
                if (!selected) {
                  _onTap(context, labels[index]);
                }
              },
              child: Container(
                padding: const EdgeInsets.only(top: 13, bottom: 12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: selected ? cyan : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icons[index],
                      size: 21,
                      color: selected
                          ? purple
                          : index == 2
                          ? const Color(0xFFFF9855)
                          : const Color(0xFFBFC5E4),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[index],
                      style: TextStyle(
                        color: selected ? purple : muted,
                        fontSize: 9,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
